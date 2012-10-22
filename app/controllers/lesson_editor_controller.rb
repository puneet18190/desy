class LessonEditorController < ApplicationController
  
  before_filter :initialize_lesson_with_owner
  
  def index
  end
  
end
