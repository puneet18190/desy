class LessonsController < ApplicationController
  
  def index
    @lessons = @current_user.own_lessons(50)
    @lessons.each do |l|
      l.set_status @current_user.id
    end
    @where = 'lessons'
  end
  
end
