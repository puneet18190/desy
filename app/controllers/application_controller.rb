class ApplicationController < ActionController::Base
  OUT_OF_AUTHENTICATION_ACTIONS = [:page_not_found]
  OUT_OF_AUTHENTICATION_ACTIONS << :set_locale if Desy::MORE_THAN_ONE_LANGUAGE

  protect_from_forgery

  before_filter :get_locale if Desy::MORE_THAN_ONE_LANGUAGE
  before_filter :authenticate, :initialize_location, :initialize_players_counter, except: OUT_OF_AUTHENTICATION_ACTIONS

  attr_reader :current_user
  helper_method :current_user

  def page_not_found
    # In production pages with 404 status are catched by the web server,
    # so we don't make the effort to render a 404 page
    render text: '<h1>Page not found</h1>', status: 404, layout: false
  end

  if Desy::MORE_THAN_ONE_LANGUAGE
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
    def get_locale
      I18n.locale = session[:locale] || I18n.default_locale
    end
  end
  
  def initialize_players_counter
    @video_counter = [SecureRandom.urlsafe_base64(16), 1]
    @audio_counter = [SecureRandom.urlsafe_base64(16), 1]
  end
  
  def prepare_lesson_for_js
    if !@lesson.nil?
      @lesson = Lesson.find_by_id @lesson.id
      @lesson.set_status current_user.id
    end
  end
  
  def prepare_media_element_for_js
    if !@media_element.nil?
      @media_element = MediaElement.find_by_id @media_element.id
      @media_element.set_status current_user.id
    end
  end
  
  def initialize_lesson_with_owner
    initialize_lesson
    update_ok(@lesson && current_user.id == @lesson.user_id)
  end
  
  def initialize_lesson
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @lesson = Lesson.find_by_id @lesson_id
    update_ok(!@lesson.nil?)
  end
  
  def initialize_lesson_destination
    @destination = params[:destination]
    update_ok(ButtonDestinations::LESSONS.include?(@destination))
  end
  
  def initialize_media_element_with_owner_or_public
    initialize_media_element
    update_ok(@media_element && (@media_element.is_public || current_user.id == @media_element.user_id))
  end
  
  def initialize_media_element_with_owner_and_private
    initialize_media_element_with_owner
    update_ok(@media_element && !@media_element.is_public)
  end
  
  def initialize_media_element_with_owner
    initialize_media_element
    update_ok(@media_element && current_user.id == @media_element.user_id)
  end
  
  def initialize_media_element
    @media_element_id = correct_integer?(params[:media_element_id]) ? params[:media_element_id].to_i : 0
    @media_element = MediaElement.find_by_id @media_element_id
    update_ok(!@media_element.nil?)
  end
  
  def initialize_media_element_destination
    @destination = params[:destination]
    update_ok(ButtonDestinations::MEDIA_ELEMENTS.include?(@destination))
  end
  
  def initialize_position
    @position = correct_integer?(params[:position]) ? params[:position].to_i : 0
    update_ok(@position > 0)
  end
  
  def initialize_layout
    @delete_item = params[:delete_item]
    if !request.xhr?
      @notifications = current_user.notifications_visible_block 0, SETTINGS['notifications_loaded_together']
      @new_notifications = current_user.number_notifications_not_seen
      @offset_notifications = @notifications.length
      @tot_notifications = current_user.tot_notifications_number
    end
  end
  
  def initialize_location
    @where = controller_name
  end
  
  def authenticate
    return redirect_to root_path(redirect_to: request.fullpath, login: true) unless current_user
  end
  
  def admin_authenticate
    return redirect_to root_path(redirect_to: request.fullpath, login: true) if not current_user or not current_user.admin?
  end

  def current_user
    @current_user ||= ( session[:user_id] and User.confirmed.find_by_id(session[:user_id]) )
  end

  def current_user=(user)
    session[:user_id] = user ? user.id : nil
    @current_user = user
  end
  
  def render_js_or_html_index
    render 'index', formats: [request.xhr? ? :js : :html]
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
  def update_ok(condition)
    @ok = true if @ok.nil?
    @ok = @ok && condition
  end
  
  def convert_item_error_messages(errors)
    resp = []
    media_errors = errors.delete(:media)
    sti_type_errors = errors.delete(:sti_type)
    subject_id_errors = errors.delete(:subject_id)
    errors2 = errors.to_s
    if !(/can't be blank/ =~ errors2).nil? || !(/is too long/ =~ errors2).nil? || !(/is too short/ =~ errors2).nil?
      resp << t('forms.error_captions.fill_all_the_fields_or_too_long')
    end
    flag = false
    if errors.has_key? :tags
      errors[:tags].each do |v|
        if !flag && v == 'are not enough'
          flag = true
          resp << t('forms.error_captions.tags_are_not_enough')
        end
      end
    end
    errors[:media] = media_errors if !media_errors.nil?
    errors[:sti_type] = sti_type_errors if !sti_type_errors.nil?
    errors[:subject_id] = subject_id_errors if !subject_id_errors.nil?
    resp
  end
  
  def convert_lesson_editor_messages(errors)
    resp = convert_item_error_messages errors
    resp << t('forms.error_captions.subject_missing_in_lesson') if errors.has_key? :subject_id
    resp
  end
  
  def convert_media_element_uploader_messages(errors)
    resp = convert_item_error_messages errors
    if errors.has_key? :media
      errors[:media].each do |em|
        return ([t('forms.error_captions.media_blank')] + resp) if em == "can't be blank"
      end
      if !(/unsupported format/ =~ errors[:media].to_s).nil? || !(/invalid extension/ =~ errors[:media].to_s).nil?
        return [t('forms.error_captions.media_unsupported_format')] + resp
      end
      if !(/invalid filename/ =~ errors[:media].to_s).nil?
        return [t('forms.error_captions.media_invalid_filename')] + resp
      end
      return [t('forms.error_captions.media_generic_error')] + resp
    else
      if errors.has_key? :sti_type
        return [t('forms.error_captions.media_unsupported_format')] + resp
      else
        return resp
      end
    end
  end
  
  def logged_in?
    current_user
  end
  
end
