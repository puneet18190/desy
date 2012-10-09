class LessonsController < ApplicationController
  
  def index
    @lessons = @current_user.lessons
    @where = 'lessons'
  end
  
end
