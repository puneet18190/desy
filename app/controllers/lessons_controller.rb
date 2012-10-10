class LessonsController < ApplicationController
  
  FOR_PAGE = CONFIG['compact_lesson_pagination']
  
  def index
    page = (params[:page].blank? || params[:page].to_i > 0) ? 1 : params[:page].to_i
    @lessons = @current_user.own_lessons(page, FOR_PAGE)
    @lessons.each do |l|
      l.set_status @current_user.id
    end
    @where = 'lessons'
    @new_notifications = 0
    @notifications = []
  end
  
end
