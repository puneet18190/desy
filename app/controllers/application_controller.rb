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
    @ok = (@current_user.id == @lesson.user_id) if @ok
  end
  
  def initialize_lesson
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @lesson = Lesson.find_by_id @lesson_id
    @ok = !@lesson.nil?
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
    @destination = params[:destination]
    @ok = false if !ButtonDestinations::MEDIA_ELEMENTS.include?(@destination)
  end
  
  def initialize_layout
    @js_reload = !params.slice(:page, :for_page, :display, :filter, :delete_item).empty?
    @delete_item = params[:delete_item]
    if @delete_item.blank?
      @notifications = Notification.visible_block(@current_user.id, 0, CONFIG['notifications_loaded_together'])
      @new_notifications = Notification.number_not_seen(@current_user.id)
      @offset_notifications = @notifications.length
      @tot_notifications = Notification.count_tot(@current_user.id)
    end
  end
  
  def initialize_location
    @where = params[:controller]
  end
  
  def authenticate # FIXME va sistemato con la vera autenticazione
    @current_user = User.find_by_email(CONFIG['admin_email'])
    session[:user_id] = @current_user.id
  end
  
  def render_js_or_html_index
    respond_to do |format|
      format.js do
        if @js_reload
          render 'index.js'
        end
      end
      format.html do
        if !@js_reload
          render 'index.html'
        end
      end
    end
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
end
