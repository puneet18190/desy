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
  
  skip_before_filter :authenticate, :only => [:index, :load_slide]
  before_filter :skip_authenticate_user_if_token, :only => :index
  before_filter :skip_authenticate_user_if_token_with_three_slides, :only => :load_slide
  
  # === Description
  #
  # Index of a single lesson viewer; it's not necessary to authenticate, if in the url is present the correct token of the lesson
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * LessonViewerController#skip_authenticate_user_if_token
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
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
  
  # === Description
  #
  # Index of the playlist viewer
  #
  # === Mode
  #
  # Html
  #
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
  
  # === Description
  #
  # Loads a new slide in the lesson viewer; it's not necessary to authenticate, if in the url is present the correct token of the lesson
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonViewerController#skip_authenticate_user_if_token_with_three_slides
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def load_slide
  end
  
  private
  
  # It uses LessonViewerController#skip_authenticate_user_if_token, and moreover checks that the slide belongs to the lesson
  def skip_authenticate_user_if_token_with_three_slides # :doc:
    skip_authenticate_user_if_token
    @slide_id = correct_integer?(params[:slide_id]) ? params[:slide_id].to_i : 0
    @slide = Slide.find_by_id @slide_id
    update_ok(@slide && @lesson && @lesson.id == @slide.lesson_id)
    if @ok
      @prev_slide = @slide.get_adhiacent_slide_in_lesson_viewer(current_user.id, params[:with_playlist].present?, true)
      @next_slide = @slide.get_adhiacent_slide_in_lesson_viewer(current_user.id, params[:with_playlist].present?, false)
      update_ok(!@prev_slide.nil? && !@next_slide.nil?)
      @prev_lesson = Lesson.find_by_id @prev_slide.lesson_id
      @next_lesson = Lesson.find_by_id @next_slide.lesson_id
      update_ok(!@prev_lesson.nil? && !@next_lesson.nil?)
    end
  end
  
  # If the user has the token, it's not necessary to check that the lesson is public
  def skip_authenticate_user_if_token # :doc:
    initialize_lesson
    update_ok(@lesson.is_public || (logged_in? && session[:user_id].to_i == @lesson.user_id)) if @ok && @lesson.token != params[:token]
  end
  
end
