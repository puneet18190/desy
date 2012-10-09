class LessonsController < ApplicationController
  
  def index
    @lessons = @current_user.own_lessons(50)
    @where = 'lessons'
  end
  
end
