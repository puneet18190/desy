class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login
  
  private
  
  def reload_lesson
    @lesson = Lesson.find_by_id @lesson.id if !@lesson.nil?
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
  
  def require_login
    @current_user = User.find_by_email(CONFIG['admin_email'])
    # TODO questa parte qui sotto andrà preservata anche quando ci sarà la autenticazione vera
    @where = params[:controller]
    @notifications = Notification.visible_block(@current_user.id, CONFIG['notifications_loaded_together'])
    @new_notifications = Notification.number_not_seen(@current_user.id)
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
end
