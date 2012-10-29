class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login, :initialize_location
  
  private
  
  def initialize_template
    @respond_instructions = ButtonDestinations.get @destination, params[:action], @container
    @ok = false if @respond_instructions == {}
  end
  
  def prepare_lesson_for_js
    if !@lesson.nil?
      @lesson = Lesson.find_by_id @lesson.id
      @lesson.set_status @current_user.id
    end
  end
  
  def prepare_media_element_for_js
    if !@media_element.nil?
      @media_element = MediaElement.find_by_id @media_element.id
      @media_element.set_status @current_user.id
    end
  end
  
  def initialize_lesson_with_owner
    initialize_lesson
    @ok = (@current_user.id == @lesson.user_id) if @ok
  end
  
  def initialize_lesson
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @lesson = Lesson.find_by_id @lesson_id
    @ok = !@lesson.nil?
    initialize_button_destination
    @ok = false if !ButtonDestinations::LESSONS.include?(@destination)
    initialize_template
  end
  
  def initialize_button_destination
    @container = params[:container]
    @destination = params[:destination]
  end
  
  def initialize_media_element_with_owner
    initialize_media_element
    @ok = (@current_user.id == @media_element.user_id) if @ok
  end
  
  def initialize_media_element
    @media_element_id = correct_integer?(params[:media_element_id]) ? params[:media_element_id].to_i : 0
    @media_element = MediaElement.find_by_id @media_element_id
    @ok = !@media_element.nil?
    initialize_button_destination
    @ok = false if !ButtonDestinations::MEDIA_ELEMENTS.include?(@destination)
    initialize_template
  end
  
  def initialize_layout
    if params[:js_reload] != 'true'
      @js_reload = false
      @notifications = Notification.visible_block(@current_user.id, 0, CONFIG['notifications_loaded_together'])
      @new_notifications = Notification.number_not_seen(@current_user.id)
      @offset_notifications = @notifications.length
      @tot_notifications = Notification.count_tot(@current_user.id)
    else
      @js_reload = true
      @delete_item = params[:delete_item]
    end
  end
  
  def initialize_location
    @where = params[:controller]
    @html_params = get_html_button_params
  end
  
  def require_login
    @current_user = User.find_by_email(CONFIG['admin_email'])
    session[:user_id] = @current_user.id
    # TODO questa parte qui sotto andrà preservata anche quando ci sarà la autenticazione vera
  end
  
  def respond_standard_js
    if @respond_instructions[:template_path] == false
      redirect_to @respond_instructions[:reload_url]
      return
    end
    case @respond_instructions[:item]
      when 'lesson'
        prepare_lesson_for_js
      when 'media_element'
        prepare_media_element_for_js
    end
    respond_to do |format|
      format.js do
        render @respond_instructions[:template_path]
      end
    end
  end
  
  def render_js_or_html_index
    if @js_reload
      respond_to do |format|
        format.js do
          render 'index.js.erb'
        end
      end
    else
      render 'index.html.erb'
    end
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
  def get_html_button_params
    resp = ""
    if params[:page].blank?
      resp = "N"
    else
      resp = "#{resp}#{params[:page]}"
    end
    if params[:for_page].blank?
      resp = "#{resp}-N"
    else
      resp = "#{resp}-#{params[:for_page]}"
    end
    if params[:filter].blank?
      resp = "#{resp}-N"
    else
      resp = "#{resp}-#{params[:filter]}"
    end
    if params[:format].blank?
      resp = "#{resp}-N"
    else
      resp = "#{resp}-#{params[:format]}"
    end
    resp
  end
  
end
