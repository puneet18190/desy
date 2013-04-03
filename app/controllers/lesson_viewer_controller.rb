# == Description
#
# Contains the actions used in the lesson viewer (view sinle lessons, or view your whole playlist)
#
# == Models used
#
# * Lesson
# * VirtualClassroomLesson
#
class LessonViewerController < ApplicationController
  
  skip_before_filter :authenticate, :only => :index
  before_filter :skip_authenticate_user_if_token, :only => :index
  before_filter :skip_authenticate_user_if_token_with_slide, :only => :load_slide
  
  def index
    if !@ok
      redirect_to '/dashboard'
    else
      @is_back = (!params[:back].nil? && !params[:back].empty?)
      @with_exit = params[:token].nil? || params[:token].empty?
      @back = params[:back]
      @slides = @lesson.slides.order(:position)
    end
  end
  
  def playlist
    @is_back = true
    @with_exit = false
    @back = '/virtual_classroom'
    @slides = current_user.playlist_for_viewer
    @vc_lessons = current_user.playlist
    if @vc_lessons.length == 0
      redirect_to '/dashboard'
      return
    end
  end
  
  def load_slide
  end
  
  private
  
  def skip_authenticate_user_if_token_with_slide # :doc:
    skip_authenticate_user_if_token
    @slide_id = correct_integer?(params[:slide_id]) ? params[:slide_id].to_i : 0
    @slide = Slide.find_by_id @slide_id
    update_ok(@slide && @lesson && @lesson.id == @slide.lesson_id)
  end
  
  def skip_authenticate_user_if_token # :doc:
    initialize_lesson
    update_ok(@lesson.is_public || (logged_in? && session[:user_id].to_i == @lesson.user_id)) if @ok && @lesson.token != params[:token]
  end
  
end
