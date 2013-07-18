require 'filename_token'

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
# 1. *before_validation* saves the +title+ from the attachment if it's not present
#
# == Database callbacks
#
# 1. *cascade* *destruction* for the associated table DocumentsSlide
#
class Document < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include ActionView::Helpers
  include FilenameToken
  
  # Maximum length of the title
  MAX_TITLE_LENGTH = (I18n.t('language_parameters.document.length_title') > 255 ? 255 : I18n.t('language_parameters.document.length_title'))
  
  serialize :metadata, OpenStruct
  
  attr_accessible :title, :description, :attachment

  mount_uploader :attachment, DocumentUploader
  
  belongs_to :user
  has_many :documents_slides
  
  validates_presence_of :user_id, :title, :attachment
  validates_numericality_of :user_id, :only_integer => true, :greater_than => 0
  validates_length_of :title, :maximum => MAX_TITLE_LENGTH
  validates_length_of :description, :maximum => I18n.t('language_parameters.document.length_description')
  validate :validate_associations, :validate_impossible_changes
  
  before_validation :init_validation, :set_title_from_filename
  before_save :set_size
  
  # Returns the size and extension in a nice way for the views
  def size_and_extension
    "#{extension}, #{humanized_size}"
  end
  
  # Returns the icon, depending on the extension
  def icon_path # TODO controllarlo e completarlo
    case extension
      when '.ppt', '.pptx'                           then 'documents/ppt.svg'
      when '.doc', '.docx', '.pages', '.odt', '.txt' then 'documents/doc.svg'
      when '.zip'                                    then 'documents/zip.svg'
      when '.xls', '.xlsx', '.numbers', '.ods'       then 'documents/exc.svg'
      when '.pdf', '.ps'                             then 'documents/pdf.svg'
      else 'documents/unknown.svg'
    end
  end
  
  # Returns the title associated to the icon
  def icon_title
    my_title = icon_path.split('/').last.split('.').first
    I18n.t("titles.documents.#{my_title}")
  end
  
  # Sets metadata
  # TODO
  def set_metadata(size)
    self.metadata.size = size
  end

  # Returns the extension of the attachment after an upload
  def uploaded_filename_without_extension
    attachment.try(:original_filename_without_extension)
  end
  
  def size
    metadata.size
  end

  def size=(size)
    metadata.size = size
  end

  # TODO
  def humanized_size
    size
  end

  def url
    attachment.url
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

  def set_size
    self.size = attachment.size if attachment.size
  end
  
  # Sets automatically the title from the file title if it's nil
  def set_title_from_filename
    self.title = uploaded_filename_without_extension.humanize[0, MAX_TITLE_LENGTH] if title.blank? && uploaded_filename_without_extension
    true
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
    errors.add(:user_id, :cant_be_changed) if @document && @document.user_id != self.user_id
  end
  
end
