class LessonViewerController < ApplicationController
  
#  before_filter 
  
  def index
    @lesson = Lesson.find params[:lesson_id]
    @slides = @lesson.slides.order :position
    @slide = @slides.first
    #TODO pass a parameter for the slide to redirect to after add_slide
    #@slide_to = params[:slide_position] if params[:slide_position]
  end
  
  def playlist
    @playlist = @current_user.playlist
  end
  
end
