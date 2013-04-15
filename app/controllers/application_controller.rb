# == Description
#
# It contains the general filters and methods used all over the application's controllers. The following filters are forced all over the application, when not specified otherwise (moreover, they are *always* skipped in ApplicationController#page_not_found, ApplicationController#set_locale):
# * ApplicationController#authenticate
# * ApplicationController#initialize_location
# * ApplicationController#initialize_players_counter
#
class ApplicationController < ActionController::Base
  
  # List of actions that in no case require the autentication.
  OUT_OF_AUTHENTICATION_ACTIONS = [:page_not_found]
  OUT_OF_AUTHENTICATION_ACTIONS << :set_locale if Desy::MORE_THAN_ONE_LANGUAGE
  
  protect_from_forgery
  
  before_filter :get_locale if Desy::MORE_THAN_ONE_LANGUAGE
  before_filter :authenticate, :initialize_location, :initialize_players_counter, :except => OUT_OF_AUTHENTICATION_ACTIONS
  
  # The user who is logged in in this section
  attr_reader :current_user
  helper_method :current_user
  
  # In *production* environment pages with 404 status are catched by the web server, so we don't make the effort to render a 404 page
  def page_not_found
    render :text => '<h1>Page not found</h1>', :status => 404, :layout => false
  end
  
  if Desy::MORE_THAN_ONE_LANGUAGE
    # Action that sets the current language of the application
    def set_locale
      available_languages = SETTINGS['languages']
      if i = available_languages.map(&:to_s).index(params[:locale])
        session[:locale] = available_languages[i]
      end
      redirect_to root_path
    end
  end
  
  private
  
  if Desy::MORE_THAN_ONE_LANGUAGE
    # Gets the current language (see ApplicationController#set_locale)
    def get_locale # :doc:
      I18n.locale = session[:locale] || I18n.default_locale
    end
  end
  
  # Initializes an incremental unique HTML identifier for all the instances of audio and video players (necessary because it's not possible to use the ID of the elements, since the same audio or video may appear more than once in the same page
  def initialize_players_counter # :doc:
    @video_counter = [SecureRandom.urlsafe_base64(16), 1]
    @audio_counter = [SecureRandom.urlsafe_base64(16), 1]
  end
  
  # Reloads the lesson and sets the status using Lesson#set_status: used for Ajax actions
  def prepare_lesson_for_js # :doc:
    if !@lesson.nil?
      @lesson = Lesson.find_by_id @lesson.id
      @lesson.set_status current_user.id
    end
  end
  
  # Reloads the element and sets the status using Lesson#set_status: used for Ajax actions
  def prepare_media_element_for_js # :doc:
    if !@media_element.nil?
      @media_element = MediaElement.find_by_id @media_element.id
      @media_element.set_status current_user.id
    end
  end
  
  # Uses ApplicationController#initialize_lesson and additionally checks if the logged user owns the lesson
  def initialize_lesson_with_owner # :doc:
    initialize_lesson
    update_ok(@lesson && current_user.id == @lesson.user_id)
  end
  
  # Checks if the parameter +lesson_id+ is correct and a corresponding lesson exists
  def initialize_lesson # :doc:
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @lesson = Lesson.find_by_id @lesson_id
    update_ok(!@lesson.nil?)
  end
  
  # Initializes the attribute +destination+ for the lesson, and checks if it's correct (see ButtonDestinations)
  def initialize_lesson_destination # :doc:
    @destination = params[:destination]
    update_ok(ButtonDestinations::LESSONS.include?(@destination))
  end
  
  # Uses ApplicationController#initialize_media_element and returns true if additionally the logged user owns the element or the element is public
  def initialize_media_element_with_owner_or_public # :doc:
    initialize_media_element
    update_ok(@media_element && (@media_element.is_public || current_user.id == @media_element.user_id))
  end
  
  # Uses ApplicationController#initialize_media_element_with_owner and returns true if additionally the element is private
  def initialize_media_element_with_owner_and_private # :doc:
    initialize_media_element_with_owner
    update_ok(@media_element && !@media_element.is_public)
  end
  
  # Uses ApplicationController#initialize_media_element and returns true if additionally the logged user owns the element
  def initialize_media_element_with_owner # :doc:
    initialize_media_element
    update_ok(@media_element && current_user.id == @media_element.user_id)
  end
  
  # Checks if the parameter +media_element_id+ is correct and a corresponding element exists
  def initialize_media_element # :doc:
    @media_element_id = correct_integer?(params[:media_element_id]) ? params[:media_element_id].to_i : 0
    @media_element = MediaElement.find_by_id @media_element_id
    update_ok(!@media_element.nil?)
  end
  
  # Initializes the attribute +destination+ for the element, and checks if it's correct (see ButtonDestinations)
  def initialize_media_element_destination # :doc:
    @destination = params[:destination]
    update_ok(ButtonDestinations::MEDIA_ELEMENTS.include?(@destination))
  end
  
  # Initializes the attribute +position+ extracting it from +params+
  def initialize_position # :doc:
    @position = correct_integer?(params[:position]) ? params[:position].to_i : 0
    update_ok(@position > 0)
  end
  
  # Initializes all the objects which are necessary in the main sections (for instance, anything related to notifications, see NotificationsController); additionally, it manages also the case in which it's necessary the effect of removing a lesson or an element from the page
  def initialize_layout # :doc:
    @delete_item = params[:delete_item]
    if !request.xhr?
      @notifications = current_user.notifications_visible_block 0, SETTINGS['notifications_loaded_together']
      @new_notifications = current_user.number_notifications_not_seen
      @offset_notifications = @notifications.length
      @tot_notifications = current_user.tot_notifications_number
    end
  end
  
  # Initializes the attribute called +where+ with the name of the controller who called the action
  def initialize_location # :doc:
    @where = controller_name
  end
  
  # Authenticates the user
  def authenticate # :doc:
    return redirect_to root_path(redirect_to: request.fullpath, login: true) unless current_user
  end
  
  # Authenticates the user, and it must be admin (see User#admin?)
  def admin_authenticate # :doc:
    return redirect_to root_path(redirect_to: request.fullpath, login: true) if not current_user or not current_user.admin?
  end
  
  # Returns the logged user
  def current_user # :doc:
    @current_user ||= ( session[:user_id] and User.confirmed.find_by_id(session[:user_id]) )
  end
  
  # Setter method for the attribute current_user
  def current_user=(user) # :doc:
    session[:user_id] = user ? user.id : nil
    @current_user = user
  end
  
  # Used in all the actions which have double possible rendering (Html + Ajax, see for instance DashboardController#index)
  def render_js_or_html_index # :doc:
    render 'index', formats: [request.xhr? ? :js : :html]
  end
  
  # Used in ApplicationController#initialize_lesson and similar methods, to check if the id passed as parameter is a correct integer
  def correct_integer?(x) # :doc:
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
  # Used as a submethod to filters like ApplicationController#initialize_lesson: this method allows these filters to be used without a specified order, it's not necessary that the attribute +ok+ has been already initialized
  def update_ok(condition) # :doc:
    @ok = true if @ok.nil?
    @ok = @ok && condition
  end
  
  # Used for errors in forms of elements general information: converts an item of type ActiveSupport::OrderedHash (errors.messages) into a translated message for the user.
  def convert_item_error_messages(errors) # :doc:
    resp = []
    media_errors = errors.delete(:media)
    sti_type_errors = errors.delete(:sti_type)
    subject_id_errors = errors.delete(:subject_id)
    if errors.has_key?(:title) || errors.has_key?(:description)
      resp << t('forms.error_captions.fill_all_the_fields_or_too_long')
    end
    flag = false
    resp << t('forms.error_captions.tags_are_not_enough') if errors.has_key? :tags
    errors[:media] = media_errors if !media_errors.nil?
    errors[:sti_type] = sti_type_errors if !sti_type_errors.nil?
    errors[:subject_id] = subject_id_errors if !subject_id_errors.nil?
    resp
  end
  
  # Used for errors in forms of lessons general information: converts an item of type ActiveSupport::OrderedHash (errors.messages) into a translated message for the user.
  def convert_lesson_editor_messages(errors) # :doc:
    resp = convert_item_error_messages errors
    resp << t('forms.error_captions.subject_missing_in_lesson') if errors.has_key? :subject_id
    resp
  end
  
  # Used for errors in forms of element uploader: converts an item of type ActiveModel::Errors into a translated message for the user.
  def convert_media_element_uploader_messages(errors) # :doc:
    return [t('forms.error_captions.media_folder_size_exceeded')] if errors.added? :media, :folder_size_exceeded

    resp = convert_item_error_messages errors.messages
    if errors.messages.has_key? :media && errors.messages[:media].any?
      return ([t('forms.error_captions.media_blank')] + resp) if errors.added? :media, :blank
      if !(/unsupported format/ =~ errors.messages[:media].to_s).nil? || !(/invalid extension/ =~ errors.messages[:media].to_s).nil?
        return [t('forms.error_captions.media_unsupported_format')] + resp
      end
      return [t('forms.error_captions.media_generic_error')] + resp
    else
      if errors.messages.has_key? :sti_type
        return [t('forms.error_captions.media_unsupported_format')] + resp
      else
        return resp
      end
    end
  end
  
  # Used for errors in forms of user profile: converts an item of type ActiveModel::Errors into a translated message for the user.
  def convert_user_error_messages(errors) # :doc:
    pas_min = SETTINGS['minimum_password_length']
    pas_max = SETTINGS['maximum_password_length']
    resp = {
      :general => [],
      :subjects => [],
      :policies => [],
      :location => []
    }
    resp[:general] << t('forms.error_captions.fill_all_the_fields_or_too_long') if (errors.messages.keys & [:name, :surname]).any?
    resp[:general] << t('forms.error_captions.not_valid_email') if errors.messages.has_key? :email
    resp[:location] << t('forms.error_captions.choose_a_location', :location => Location.base_label.downcase) if errors.messages.has_key? :location_id
    resp[:subjects] << t('forms.error_captions.select_at_least_a_subject') if errors.messages.has_key? :users_subjects
    if errors.messages.has_key? :password
      if errors.added?(:password, :too_short, {:count => pas_min}) || errors.added?(:password, :too_long, {:count => pas_max})
        if pas_max.nil?
          resp[:general] << t('forms.error_captions.password_too_short', :min => pas_min)
        else
          resp[:general] << t('forms.error_captions.password_not_in_range', :min => pas_min, :max => pas_max)
        end
      elsif errors.added? :password, :confirmation
        resp[:general] << t('forms.error_captions.password_doesnt_match_confirmation')
      else
        resp[:general] << t('forms.error_captions.invalid_password')
      end
    end
    SETTINGS['user_registration_policies'].each_with_index do |policy, index|
      if errors.messages.has_key? :"#{policy}"
        resp[:policies] << t('forms.error_captions.policy_not_accepted', :policy => t('registration.policies')[index]['title'])
      end
    end
    resp
  end
  
  # Checks if there is a logged user
  def logged_in? # :doc:
    current_user
  end
  
end
