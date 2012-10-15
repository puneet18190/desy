class VirtualClassroomController < ApplicationController
  
  def add_lesson
    initialize_lesson
    if @ok
      if !@lesson.add_to_virtual_classroom(@current_user.id)
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_adding_to_virtual_classroom')
    end
    reload_lesson
  end
  
  def remove_lesson # qui ci vuole un filtro
    initialize_lesson
    if @ok
      if !@lesson.remove_from_virtual_classroom(@current_user.id)
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_removing_from_virtual_classroom')
    end
    reload_lesson
  end
  
end
