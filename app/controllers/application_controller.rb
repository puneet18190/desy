class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :initialize_location
  
  private

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
    update_ok(@lesson && @current_user.id == @lesson.user_id)
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
  
  def initialize_media_element_with_owner_and_private
    initialize_media_element_with_owner
    update_ok(@media_element && !@media_element.is_public)
  end
  
  def initialize_media_element_with_owner
    initialize_media_element
    update_ok(@media_element && @current_user.id == @media_element.user_id)
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
      @notifications = @current_user.notifications_visible_block 0, CONFIG['notifications_loaded_together']
      @new_notifications = @current_user.number_notifications_not_seen
      @offset_notifications = @notifications.length
      @tot_notifications = @current_user.tot_notifications_number
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
  
  def update_ok(condition)
    @ok = true if @ok.nil?
    @ok = @ok && condition
  end
  
  def logged_in?
    session[:user_id].class == Fixnum && User.exists?(session[:user_id])
  end
  
end
