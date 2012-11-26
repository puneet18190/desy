class LessonViewerController < ApplicationController
  
  skip_before_filter :authenticate, :only => :index
  before_filter :skip_authenticate_user_if_token, :only => :index
  
  def index
    if !@ok
      redirect_to '/dashboard'
    end
    #TODO pass a parameter for the slide to redirect to after add_slide
    #@slide_to = params[:slide_position] if params[:slide_position]
  end
  
  def playlist
    @playlist = @current_user.playlist
  end
  
  private
  
  def skip_authenticate_user_if_token
    initialize_lesson
    update_ok(@lesson.is_public || (logged_in? && session[:user_id].to_i == @lesson.user_id)) if @ok && @lesson.token != params[:token]
  end
  
end
