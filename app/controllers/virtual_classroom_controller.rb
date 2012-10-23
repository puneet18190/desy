class VirtualClassroomController < ApplicationController
  
  before_filter :initialize_lesson, :only => [:add_lesson, :remove_lesson]
  # manca il initialize_notifications??
  
  def add_lesson
    if @ok
      if !@lesson.add_to_virtual_classroom(@current_user.id)
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_adding_to_virtual_classroom')
    end
    respond_standard_js
  end
  
  def remove_lesson
    if @ok
      if !@lesson.remove_from_virtual_classroom(@current_user.id)
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_removing_from_virtual_classroom')
    end
    respond_standard_js
  end
  
end
