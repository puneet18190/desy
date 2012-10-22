class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login
  
  private
  
  def initialize_template
    resp = ButtonDestinations.get @destination, params[:action]
    @ok = false if resp == {}
    @item = resp[:item]
    @template_path = resp[:path]
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
    initialize_button_destination_for_lessons
    initialize_template
  end
  
  def initialize_button_destination_for_lessons
    @destination = params[:destination]
    @ok = false if !ButtonDestinations::LESSONS.include?(@destination)
  end
  
  def initialize_media_element_with_owner
    initialize_media_element
    @ok = (@current_user.id == @media_element.user_id) if @ok
  end
  
  def initialize_media_element
    @media_element_id = correct_integer?(params[:media_element_id]) ? params[:media_element_id].to_i : 0
    @media_element = MediaElement.find_by_id @media_element_id
    @ok = !@media_element.nil?
    initialize_button_destination_for_media_elements
    initialize_template
  end
  
  def initialize_button_destination_for_media_elements
    @destination = params[:destination]
    @ok = false if !ButtonDestinations::MEDIA_ELEMENTS.include?(@destination)
  end
  
  def initialize_notifications
    if @offset_notifications.nil?
      get_current_notification_block(0, CONFIG['notifications_loaded_together'])
    else
      get_current_notification_block(@offset_notifications, CONFIG['notifications_loaded_together'])
    end
    @new_notifications = Notification.number_not_seen(@current_user.id)
    @offset_notifications = @offset_notifications.nil? ? @notifications.length : (@offset_notifications + @notifications.length)
  end
  
  def get_current_notification_block(offset, limit)
    resp = Notification.visible_block(@current_user.id, offset, limit)
    @notifications = resp[:content]
    @notifications_last_page = resp[:last_page]
  end
  
  def initialize_location
    @where = params[:controller]
  end
  
  def require_login
    @current_user = User.find_by_email(CONFIG['admin_email'])
    # TODO questa parte qui sotto andrà preservata anche quando ci sarà la autenticazione vera
    initialize_location
    initialize_notifications
  end
  
  def respond_standard_js
    if @template_path.nil?
      render :nothing => true
      return
    end
    case @item
      when 'lesson'
        prepare_lesson_for_js
      when 'media_element'
        prepare_media_element_for_js
    end
    respond_to do |format|
      format.js do
        render @template_path
      end
    end
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
end
