class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :initialize_location, :set_custom_headers
  
  private

  def set_custom_headers
    response.headers["X-Frame-Options"] = "SAMEORIGIN"
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
  end
  
  def initialize_lesson_destination
    @destination = params[:destination]
    @ok = false if !ButtonDestinations::LESSONS.include?(@destination)
  end
  
  def initialize_media_element_with_owner_and_private
    initialize_media_element_with_owner
    @ok = !@media_element.is_public if @ok
  end
  
  def initialize_media_element_with_owner
    initialize_media_element
    @ok = (@current_user.id == @media_element.user_id) if @ok
  end
  
  def initialize_media_element
    @media_element_id = correct_integer?(params[:media_element_id]) ? params[:media_element_id].to_i : 0
    @media_element = MediaElement.find_by_id @media_element_id
    @ok = !@media_element.nil?
  end
  
  def initialize_media_element_destination
    @destination = params[:destination]
    @ok = false if !ButtonDestinations::MEDIA_ELEMENTS.include?(@destination)
  end
  
  def initialize_layout
    @delete_item = params[:delete_item]
    if !request.xhr?
      @notifications = Notification.visible_block(@current_user.id, 0, CONFIG['notifications_loaded_together'])
      @new_notifications = Notification.number_not_seen(@current_user.id)
      @offset_notifications = @notifications.length
      @tot_notifications = Notification.count_tot(@current_user.id)
    end
  end
  
  def initialize_location
    @where = controller_name
  end
  
  def authenticate
    if !logged_in?
      redirect_to home_path
      return
    end
    @current_user = User.find_by_id session[:user_id]
  end
  
  def render_js_or_html_index
    render (request.xhr? ? 'index.js' : 'index.html')
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
  def logged_in?
    session[:user_id].class == Fixnum && User.exists?(session[:user_id])
  end
  
end
