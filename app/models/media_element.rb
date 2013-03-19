class MediaElement < ActiveRecord::Base
  include FilenameToken
  extend LessonsMediaElementsShared
  
  self.inheritance_column = :sti_type
  
  # Questa deve stare prima delle require dei submodels, perché
  # l'after_save delle tags deve venire prima di quella dell'uploader
  after_save :update_or_create_tags
  
  # TODO estrarre da database sti_types
  IMAGE_TYPE, AUDIO_TYPE, VIDEO_TYPE = %W(Image Audio Video)
  STI_TYPES = [IMAGE_TYPE, AUDIO_TYPE, VIDEO_TYPE]
  DISPLAY_MODES = { compact: 'compact', expanded: 'expanded' }
  
  serialize :metadata, OpenStruct
  
  attr_accessible :title, :description, :media, :publication_date, :tags
  attr_reader :is_reportable, :info_changeable
  attr_accessor :skip_public_validations, :destroyable_even_if_public
  
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :media_elements_slides
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable
  has_many :taggings_tags, through: :taggings, source: :tag
  belongs_to :user
  
  validates_presence_of :user_id, :title, :description
  validates_inclusion_of :is_public, :in => [true, false]
  validates_inclusion_of :sti_type, :in => STI_TYPES
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => I18n.t('language_parameters.media_element.length_title')
  validates_length_of :description, :maximum => I18n.t('language_parameters.media_element.length_description')
  validates_presence_of :media, unless: proc{ |record| [Video, Audio].include?(record.class) && record.composing }
  validate :validate_associations, :validate_publication_date, :validate_impossible_changes, :validate_tags_length
  
  before_validation :init_validation
  before_destroy :stop_if_public, :destroy_taggings
  
  # SELECT "media_elements".* FROM "media_elements" LEFT JOIN bookmarks ON bookmarks.bookmarkable_id = media_elements.id AND bookmarks.bookmarkable_type = 'MediaElement' AND bookmarks.user_id = 1 WHERE (bookmarks.user_id IS NOT NULL OR (media_elements.is_public = false AND media_elements.user_id = 1)) ORDER BY COALESCE(bookmarks.created_at, media_elements.updated_at) DESC
  scope :of, ->(user_or_user_id) do
    user_id = user_or_user_id.instance_of?(User) ? user_or_user_id.id : user_or_user_id
    joins(sanitize_sql ["LEFT JOIN bookmarks ON 
                         bookmarks.bookmarkable_id = media_elements.id AND
                         bookmarks.bookmarkable_type = 'MediaElement' AND
                         bookmarks.user_id = %i", user_id] ).
    where('bookmarks.user_id IS NOT NULL OR (media_elements.is_public = false AND media_elements.user_id = ?)', user_id).
    order('COALESCE(bookmarks.created_at, media_elements.updated_at) DESC')
  end
  
  class << self
    
    def new_with_sti_type_inferring(attributes = nil, options = {}, &block)
      media = attributes.try :[], :media
      unless media.is_a?(ActionDispatch::Http::UploadedFile) || media.is_a?(File)
        return new_without_sti_type_inferring(attributes, options, &block)
      end
      extension = File.extname(
          case media
          when ActionDispatch::Http::UploadedFile then media.original_filename
          when File                               then media.path
          end
        ).sub(/^\./, '').downcase
      inferred_sti_type = Hash[ [Image, Video, Audio].
        map{ |v| [v, v.const_get(:EXTENSION_WHITE_LIST)] } ].
        detect{ |_,v| v.include? extension }.
        try(:first)
      unless inferred_sti_type
        return new_without_sti_type_inferring(attributes, options, &block)
      end
      inferred_sti_type.new_without_sti_type_inferring(attributes, options, &block)
    end
    alias_method_chain :new, :sti_type_inferring
    
    def extract(media_element_id, an_user_id, my_sti_type)
      media_element = find_by_id media_element_id
      return nil if media_element.nil? || media_element.sti_type != my_sti_type
      media_element.set_status(an_user_id)
      return nil if media_element.status.nil?
      media_element
    end
    
    def dashboard_emptied?(an_user_id)
      Bookmark.joins("INNER JOIN media_elements ON media_elements.id = bookmarks.bookmarkable_id AND bookmarks.bookmarkable_type = 'MediaElement'").where('media_elements.is_public = ? AND media_elements.user_id != ? AND bookmarks.user_id = ?', true, an_user_id, an_user_id).any?
    end
    
    def filetype(path)
      path = File.extname(path)
      if Audio::EXTENSION_WHITE_LIST.include?(path[1, path.length])
        return 'audio'
      elsif Video::EXTENSION_WHITE_LIST.include?(path[1, path.length])
        return 'video'
      elsif Image::EXTENSION_WHITE_LIST.include?(path[1, path.length])
        return 'image'
      else
        return nil
      end
    end
    
  end
  
  def sti_type_to_s
    I18n.t("sti_types.#{self.sti_type.downcase}")
  end
  
  def disable_lessons_containing_me
    manage_lessons_containing_me(false)
  end
  
  def enable_lessons_containing_me
    manage_lessons_containing_me(true)
  end
  
  def image?
    self.sti_type == IMAGE_TYPE
  end
  
  def audio?
    self.sti_type == AUDIO_TYPE
  end
  
  def video?
    self.sti_type == VIDEO_TYPE
  end
  
  def visive_tags
    Tagging.visive_tags(self.tags)
  end
  
  def tags
    self.new_record? ? '' : Tag.get_friendly_tags(self.id, 'MediaElement')
  end
  
  def tags=(tags)
    @tags = 
      case tags
      when String
        tags
      when Array
        tags.map(&:to_s).join(',')
      end
    @tags
  end
  
  def status(with_captions=false)
    @status.nil? ? nil : (with_captions ? MediaElement.status(@status) : @status)
  end
  
  def set_status(an_user_id)
    return if self.new_record?
    if !self.is_public && an_user_id == self.user_id
      @status = Statuses::PRIVATE
      @is_reportable = false
      @info_changeable = true
    elsif self.is_public && !self.bookmarked?(an_user_id)
      @status = Statuses::PUBLIC
      @is_reportable = true
      @info_changeable = false
    elsif self.is_public && self.bookmarked?(an_user_id)
      @status = Statuses::LINKED
      @is_reportable = true
      @info_changeable = false
    else
      @status = nil
      @is_reportable = nil
      @info_changeable = nil
    end
  end
  
  def buttons
    return [] if [@status, @is_reportable, @info_changeable].include?(nil)
    if @status == Statuses::PRIVATE
      return [Buttons::PREVIEW, Buttons::EDIT, Buttons::DESTROY]
    elsif @status == Statuses::PUBLIC
       return [Buttons::PREVIEW, Buttons::ADD]
    elsif @status == Statuses::LINKED
       return [Buttons::PREVIEW, Buttons::EDIT, Buttons::REMOVE]
    else
      return []
    end
  end
  
  def bookmarked?(an_user_id)
    return false if self.new_record?
    Bookmark.where(:user_id => an_user_id, :bookmarkable_type => 'MediaElement', :bookmarkable_id => self.id).any?
  end
  
  def check_and_destroy
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_destroying)
      return false
    end
    if self.is_public
      errors.add(:base, :cant_destroy_public)
      return false
    end
    old_id = self.id
    begin
      self.destroy
    rescue StandardError
      errors.add(:base, :problem_destroying)
      return false
    end
    if MediaElement.exists?(old_id)
      errors.add(:base, :problem_destroying)
      return false
    end
    true
  end
  
  private
  
  def validate_tags_length
    errors[:tags] << "are not enough" if @inner_tags.length < SETTINGS['min_tags_for_item']
  end
  
  def update_or_create_tags
    return true unless @inner_tags
    words = []
    @inner_tags.each do |t|
      raise ActiveRecord::Rollback if t.new_record? && !t.save
      words << t.id
      tagging = Tagging.where(:taggable_id => self.id, :taggable_type => 'MediaElement', :tag_id => t.id).first
      if tagging.nil?
        tagging = Tagging.new
        tagging.taggable_id = self.id
        tagging.taggable_type = 'MediaElement'
        tagging.tag_id = t.id
        raise ActiveRecord::Rollback if !tagging.save
      end
    end
    Tagging.where(:taggable_type => 'MediaElement', :taggable_id => self.id).each do |t|
      t.destroy if !words.include?(t.tag_id)
    end
  end
  
  def init_validation
    @media_element = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
    @inner_tags =
      if @tags.blank?
        Tag.get_tags_for_item(self.id, 'MediaElement')
      else
        resp_tags = []
        prev_tags = []
        @tags.split(',').each do |t|
          if t.present?
            t = t.to_s.strip.mb_chars.downcase.to_s
            if !prev_tags.include? t
              tag = Tag.find_or_initialize_by_word t
              resp_tags << tag if tag.valid?
            end
            prev_tags << t
          end
        end
        resp_tags
      end
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if @user.nil?
  end
  
  def validate_publication_date
    if self.is_public
      errors[:publication_date] << "is not a date" if self.publication_date.blank? || !self.publication_date.kind_of?(Time)
    else
      errors[:publication_date] << "must be blank if private" if !self.publication_date.blank?
    end
  end
  
  def validate_impossible_changes
    if @media_element.nil?
      errors[:is_public] << "must be false if new record" if self.is_public && !self.skip_public_validations
    else
      errors[:sti_type] << "is not changeable" if @media_element.sti_type != self.sti_type
      if @media_element.is_public && !self.skip_public_validations
        errors[:media] << "is not changeable for a public record" if self.changed.include? 'media'
        errors[:title] << "is not changeable for a public record" if @media_element.title != self.title
        errors[:description] << "is not changeable for a public record" if @media_element.description != self.description
        errors[:is_public] << "is not changeable for a public record" if !self.is_public
        errors[:publication_date] << "is not changeable for a public record" if @media_element.publication_date != self.publication_date
      else
        errors[:user_id] << "can't be changed" if @media_element.user_id != self.user_id
      end
    end
  end
  
  def stop_if_public
    return true if destroyable_even_if_public
    @media_element = Valid.get_association self, :id
    if @media_element.try(:is_public)
      errors.add :is_public, :undestroyable
      false
    else
      true
    end
  end
  
  def manage_lessons_containing_me(value)
    MediaElementsSlide.where(:media_element_id => id).each do |mes|
      l = mes.slide.lesson
      if video?
        l.metadata.available_video = value
      elsif audio?
        l.metadata.available_audio = value
      end
      l.save!
    end
  end
  
  def destroy_taggings
    Tagging.where(:taggable_type => 'MediaElement', :taggable_id => self.id).each do |tagging|
      tagging.destroyable = true
      tagging.destroy
    end
    true
  end
  
end
