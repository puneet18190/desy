class ReportsController < ApplicationController
  
  def lesson
    if correct_integer?(params[:lesson_id])
      @lesson_id = params[:lesson_id].to_i
      @resp = @user.report_lesson(@lesson_id, params[:content])
      @error = @user.get_base_error
    else
      @lesson_id = nil
      @resp = false
      @error = I18n.t('activerecord.errors.models.user.problem_reporting')
    end
  end
  
  def media_element
    @resp = @user.report_media_element(lesson_id, params[:content])
  end
  
end
