class LessonViewerController < ApplicationController
  
  before_filter :initialize_lesson_with_owner
  
  def index
    @lesson = Lesson.find params[:lesson_id]
    @slides = @lesson.slides.order :position
    @slide = @slides.first
    #TODO pass a parameter for the slide to redirect to after add_slide
    #@slide_to = params[:slide_position] if params[:slide_position]
  end
  
  def playlist
    #TODO to fix with method
    @lesson = Lesson.find params[:lesson_id]
    @playlist = VirtualClassroomLesson.where("user_id = ? AND position IS NOT NULL", @current_user.id).order "created_at DESC"
  end
  
end
