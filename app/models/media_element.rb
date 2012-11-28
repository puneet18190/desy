class MediaElement < ActiveRecord::Base
  
  # TODO estrarre da database sti_types
  IMAGE_TYPE = 'Image'
  AUDIO_TYPE = 'Audio'
  VIDEO_TYPE = 'Video'
  STI_TYPES = [IMAGE_TYPE, AUDIO_TYPE, VIDEO_TYPE]
  
  COLORS = {
    :red => 'B51726', # colore sfondo della componente 'testo' nella timeline nel psd dell'editor video
    :green => '#41A62A', # colore elementi didattici
    :light_green => '#95E195', # scelto da me
    :orange => '#F29400', # colore lezioni
    :blue => '#2807CE', # scelto da me
    :light_blue => '#2EAADC', # colore virtual classroom
    :white => '#F2F2F2', # scelto da me
    :black => '#373737', # colore dell'header desy
    :gray => '#7D7D7D', # scritta 'profile' nel menu quando è selezionata (non sfondo)
    :purple => '#6A05AE', # scelto da me
    :yellow => '#FDB525', # sfondo sezione 'what is DESY'
    :brown => '#622F0B', # scelto da me
    :pink => '#F4D0F3' # scelto da me
  }
  
  statuses = ::STATUSES.media_elements.marshal_dump.keys
  STATUSES = Struct.new(*statuses).new(*statuses)
  EXTENSIONS_BY_STI_TYPE = { 'Image' => %w(jpg jpeg png) }
  
  self.inheritance_column = :sti_type
  
  attr_accessible :title, :description, :media, :publication_date, :tags
  attr_reader :status, :is_reportable, :info_changeable
  attr_writer :tags
  
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :media_elements_slides
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable, :dependent => :delete_all
  belongs_to :user
  
  # FIXME aggiungere :media a validates_presence_of una volta implementati tutti gli upload
  validates_presence_of :user_id, :title, :description
  validates_inclusion_of :is_public, :in => [true, false]
  validates_inclusion_of :sti_type, :in => STI_TYPES
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => I18n.t('language_parameters.media_element.length_title')
  validates_length_of :description, :maximum => I18n.t('language_parameters.media_element.length_description')
  validate :validate_associations, :validate_publication_date, :validate_impossible_changes, :validate_tags_length
  
  before_validation :init_validation
  after_save :update_or_create_tags
  before_destroy :stop_if_public
  
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
      inferred_sti_type = EXTENSIONS_BY_STI_TYPE.detect{ |k, v| v.include? extension }.try(:first)
      unless inferred_sti_type
        return new_without_sti_type_inferring(attributes, options, &block)
      end
      inferred_sti_type.constantize.new_without_sti_type_inferring(attributes, options, &block)
    end
    alias_method_chain :new, :sti_type_inferring
  end
  
  def self.extract(media_element_id, an_user_id, my_sti_type)
    media_element = MediaElement.find_by_id media_element_id
    return nil if media_element.nil? || media_element.sti_type != my_sti_Type
    media_element.set_status(an_user_id)
    return nil if media_element.status.nil?
    media_element
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
  
  def tags
    self.new_record? ? '' : Tag.get_friendly_tags(self.id, 'MediaElement')
  end
  
  def media_from_file_path=(file_path)
    self.media = File.open(file_path)
  end
  
  def self.dashboard_emptied?(an_user_id)
    Bookmark.joins("INNER JOIN media_elements ON media_elements.id = bookmarks.bookmarkable_id AND bookmarks.bookmarkable_type = 'MediaElement'").where('media_elements.is_public = ? AND media_elements.user_id != ? AND bookmarks.user_id = ?', true, an_user_id, an_user_id).any?
  end
  
  def set_status(an_user_id)
    return if self.new_record?
    if !self.is_public && an_user_id == self.user_id
      @status = STATUSES.private
      @is_reportable = false
      @info_changeable = true
    elsif self.is_public && !self.bookmarked?(an_user_id)
      @status = STATUSES.public
      @is_reportable = true
      @info_changeable = false
    elsif self.is_public && self.bookmarked?(an_user_id)
      @status = STATUSES.linked
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
    if @status == STATUSES.private
      return [Buttons::PREVIEW, Buttons::EDIT, Buttons::DESTROY]
    elsif @status == STATUSES.public
       return [Buttons::PREVIEW, Buttons::ADD]
    elsif @status == STATUSES.linked
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
    rescue Exception
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
    errors[:tags] << "are not enough" if @inner_tags.length < CONFIG['min_tags_for_item']
  end
  
  def update_or_create_tags
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
      errors[:is_public] << "must be false if new record" if self.is_public
    else
      errors[:sti_type] << "is not changeable" if @media_element.sti_type != self.sti_type
      if @media_element.is_public
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
    @media_element = Valid.get_association self, :id
    return true if @media_element.nil?
    return !@media_element.is_public
  end
  
end
