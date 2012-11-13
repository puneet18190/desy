class MediaElement < ActiveRecord::Base
  
  statuses = ::STATUSES.media_elements.marshal_dump.keys
  STATUSES = Struct.new(*statuses).new(*statuses)
  EXTENSIONS_BY_STI_TYPE = { 'Image' => %w(jpg jpeg png) }
  
  self.inheritance_column = :sti_type
  
  attr_accessible :title, :description, :media, :publication_date
  attr_reader :status, :is_reportable, :info_changeable
  attr_accessor :tags
  
  has_many :bookmarks, :as => :bookmarkable, :dependent => :destroy
  has_many :media_elements_slides
  has_many :reports, :as => :reportable, :dependent => :destroy
  has_many :taggings, :as => :taggable, :dependent => :destroy
  belongs_to :user
  
  # FIXME aggiungere :media a validates_presence_of una volta implementati tutti gli upload
  validates_presence_of :user_id, :title, :description
  validates_inclusion_of :is_public, :in => [true, false]
  validates_inclusion_of :sti_type, :in => ['Video', 'Audio', 'Image']
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :duration, :allow_nil => true, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => I18n.t('language_parameters.media_element.length_title')
  validates_length_of :description, :maximum => I18n.t('language_parameters.media_element.length_description')
  validate :validate_associations, :validate_publication_date, :validate_impossible_changes, :validate_tags_length#, :validate_duration
  
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
    if self.tags.blank?
      @inner_tags = Tag.where('EXISTS (SELECT * FROM taggings WHERE taggings.tag_id = tags.id AND taggings.taggable_type = ? AND taggings.taggable_id = ?)', 'MediaElement', self.id)
    else
      resp_tags = []
      prev_tags = []
      self.tags.split(',').each do |t|
        if !t.blank?
          t = t.to_s.strip.mb_chars.downcase.to_s
          if !prev_tags.include? t
            tag = Tag.find_by_word t
            tag = Tag.new(:word => t) if tag.nil?
            resp_tags << tag if tag.valid?
          end
          prev_tags << t
        end
      end
      @inner_tags = resp_tags
    end
  end
  
  def validate_associations
    errors[:user_id] << "doesn't exist" if !User.exists?(self.user_id)
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
        errors[:duration] << "is not changeable for a public record" if @media_element.duration != self.duration
        errors[:is_public] << "is not changeable for a public record" if !self.is_public
        errors[:publication_date] << "is not changeable for a public record" if @media_element.publication_date != self.publication_date
      else
        errors[:user_id] << "can't be changed" if @media_element.user_id != self.user_id
      end
    end
  end
  
  # TODO implementarla
  def validate_duration
    if self.sti_type == 'Image'
      errors[:duration] << 'must be blank for images' if !self.duration.nil?
    else
      errors[:duration] << "can't be blank for videos and audios" if self.duration.nil?
    end
  end
  
  def stop_if_public
    @media_element = Valid.get_association self, :id
    return true if @media_element.nil?
    return !@media_element.is_public
  end
  
end
