# == Description
#
# ActiveRecord class that corresponds to the table +documents+.
#
# == Fields
#
# * *user_id*: id of the creator of the document
# * *title*: title
# * *description*: description
#
# == Associations
#
# * *user*: reference to the User who created the document (*belongs_to*)
# * *documents_slides*: instances of this Document contained in a slide (see DocumentsSlide) (*has_many*)
#
# == Validations
#
# * *presence* with numericality and existence of associated record for +user_id+
# * *presence* for +title+
# * *length* of +title+ and +description+ (values configured in the I18n translation file; only for title, if the value is greater than 255 it's set to 255)
# * *modifications* *not* *available* for the +user_id+
#
# == Callbacks
#
# 1. *before_validation* saves the +title+ from the attached file if it's not present
#
# == Database callbacks
#
# 1. *cascade* *destruction* for the associated table DocumentsSlide
#
class Document < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  
  # Maximum length of the title
  MAX_TITLE_LENGTH = (I18n.t('language_parameters.document.length_title') > 255 ? 255 : I18n.t('language_parameters.document.length_title'))
  
  attr_accessible :title, :description
  
  belongs_to :user
  has_many :documents_slides
  
  validates_presence_of :user_id, :title
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => MAX_TITLE_LENGTH
  validates_length_of :description, :maximum => I18n.t('language_parameters.document.length_description')
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation, :set_title_from_file
  
  # Used to sanitize title
  def title=(title)
    title = title.nil? ? nil : title.to_s
    write_attribute(:title, sanitize(title))
  end
  
  # Returns the size and extension in a nice way for the views
  def size_and_extension
    "#{self.extension}, #{self.size}"
  end
  
  # Returns the size of the attached file
  def size # TODO
    self.title.length.to_s + ' kb'
  end
  
  # Returns the big icon, depending on the extension
  def icon_path_big
    self.icon_path.gsub('documents/', 'documents/big/')
  end
  
  # Returns the icon, depending on the extension
  def icon_path # TODO
    case self.extension
      when '.ppt' then 'documents/ppt.png'
      when '.doc', '.docx', '.pages', '.odt', '.txt' then 'documents/doc.png'
      when '.gz', '.zip' then 'documents/zip.png'
      when '.xls', '.xlsx', '.numbers', '.ods' then 'documents/exc.png'
      when '.pdf', '.ps' then 'documents/pdf.png'
      else 'documents/unknown.png'
    end
  end
  
  # Returns the title associated to the icon
  def icon_title # TODO
    my_title = self.icon_path.split('/').last.split('.').first
    I18n.t("titles.documents.#{my_title}")
  end
  
  # Returns the extension of the attached file from metadata
  def extension # TODO
    case (self.id % 10)
      when 0 then '.ppt'
      when 1 then '.pdf'
      when 2 then '.doc'
      when 3 then '.docx'
      when 4 then '.odt'
      when 5 then '.zip'
      when 6 then '.pages'
      when 7 then '.ods'
      when 8 then '.xls'
      when 9 then '.svg'
    end
  end
  
  # === Description
  #
  # Destroys the document and sends notifications to the users who had a Lesson containing it.
  #
  # === Returns
  #
  # A boolean
  #
  def destroy_with_notifications
    errors.clear
    if self.new_record?
      errors.add(:base, :problem_destroying)
      return false
    end
    resp = false
    ActiveRecord::Base.transaction do
      DocumentsSlide.joins(:slide, {:slide => :lesson}).select('lessons.user_id AS my_user_id, lessons.title AS lesson_title, lessons.id AS lesson_id').group('lessons.id').where('documents_slides.document_id = ?', self.id).each do |ds|
        if ds.my_user_id.to_i != self.user_id && !Notification.send_to(ds.my_user_id.to_i, I18n.t('notifications.documents.destroyed', :lesson_title => ds.lesson_title, :document_title => self.title, :link => lesson_viewer_path(ds.lesson_id.to_i)))
          errors.add(:base, :problem_destroying)
          raise ActiveRecord::Rollback
        end
        Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => ds.lesson_id.to_i).each do |b|
          if !Notification.send_to(b.user_id, I18n.t('notifications.lessons.modified', :lesson_title => ds.lesson_title, :link => lesson_viewer_path(ds.lesson_id.to_i), :message => I18n.t('notifications.documents.standard_message_for_linked_lessons', :document_title => self.title)))
            errors.add(:base, :problem_destroying)
            raise ActiveRecord::Rollback
          end
        end
      end
      begin
        self.destroy
      rescue StandardError
        errors.add(:base, :problem_destroying)
        raise ActiveRecord::Rollback
      end
      resp = true
    end
    resp
  end
  
  # Returns true if the document has been attached to your own lessons
  def used_in_your_lessons?
    DocumentsSlide.joins(:slide, {:slide => :lesson}).where(:documents_slides => {:document_id => self.id}, :lessons => {:user_id => self.user_id}).any?
  end
  
  private
  
  # Sets automatically the title from the file title if it's nil
  def set_title_from_file
    self.title = "file_title.txt" if self.title.blank? # TODO rimpiazzarlo con titolo vero del file
  end
  
  # Validates the presence of all the associated objects
  def validate_associations
    errors.add(:user_id, :doesnt_exist) if @user.nil?
  end
  
  # Initializes validation objects (see Valid.get_association)
  def init_validation
    @document = Valid.get_association self, :id
    @user = Valid.get_association self, :user_id
  end
  
  # Validates that if the document is not new record the field +user_id+ cannot be changed
  def validate_impossible_changes
    if @document
      errors.add(:user_id, :cant_be_changed) if @document.user_id != self.user_id
    end
  end
  
end
