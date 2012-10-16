class ApplicationController < ActionController::Base
  protect_from_forgery
  
  JS_SWITCH_BUTTON_FUNCTIONS = {
    'lessons' => {
      'like' => {
        :function => 'dislikeLesson',
        :button_class => Buttons::LIKE,
        :new_button_class => Buttons::DISLIKE
      },
      'dislike' => {
        :function => 'likeLesson',
        :button_class => Buttons::DISLIKE,
        :new_button_class => Buttons::LIKE
      },
      'publish' => {
        :function => 'unpublishLesson',
        :button_class => Buttons::PUBLISH,
        :new_button_class => Buttons::UNPUBLISH
      },
      'unpublish' => {
        :function => 'publishLesson',
        :button_class => Buttons::UNPUBLISH,
        :new_button_class => Buttons::PUBLISH
      }
    },
    'virtual_classroom' => {
      'add_lesson' => {
        :function => 'removeLessonFromVirtualClassroom',
        :button_class => Buttons::ADD_VIRTUAL_CLASSROOM,
        :new_button_class => Buttons::REMOVE_VIRTUAL_CLASSROOM
      },
      'remove_lesson' => {
        :function => 'addLessonToVirtualClassroom',
        :button_class => Buttons::REMOVE_VIRTUAL_CLASSROOM,
        :new_button_class => Buttons::ADD_VIRTUAL_CLASSROOM
      }
    }
  }
  
  before_filter :require_login
  
  private
  
  def prepare_lesson_for_js
    if !@lesson.nil?
      @lesson = Lesson.find_by_id @lesson.id
      @lesson.set_status @current_user.id
      my_params = JS_SWITCH_BUTTON_FUNCTIONS[params[:controller]][params[:action]]
      @function = my_params[:function]
      @button_class = my_params[:button_class]
      @new_button_class = my_params[:new_button_class]
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
  
  def initialize_notifications
    @notifications = Notification.visible_block(@current_user.id, CONFIG['notifications_loaded_together'])
    @new_notifications = Notification.number_not_seen(@current_user.id)
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
  
  def respond_standard_js(path)
    prepare_lesson_for_js
    respond_to do |format|
      format.js { render :action => path}
    end
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
end
