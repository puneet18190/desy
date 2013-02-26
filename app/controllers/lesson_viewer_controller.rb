class LessonViewerController < ApplicationController
  
  skip_before_filter :authenticate, :only => :index
  before_filter :skip_authenticate_user_if_token, :only => :index
  before_filter :reset_players_counter, :only => :index
  
  def index
    if !@ok
      redirect_to '/dashboard'
    else
      @is_back = (!params[:back].nil? && !params[:back].empty?)
      @with_exit = params[:token].nil? || !params[:token].empty?
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
  
  private
  
  def skip_authenticate_user_if_token
    initialize_lesson
    update_ok(@lesson.is_public || (logged_in? && session[:user_id].to_i == @lesson.user_id)) if @ok && @lesson.token != params[:token]
  end
  
end
