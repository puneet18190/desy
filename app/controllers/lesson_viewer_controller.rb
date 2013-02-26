class LessonViewerController < ApplicationController
  
  skip_before_filter :authenticate, :only => :index
  before_filter :skip_authenticate_user_if_token, :only => :index
  before_filter :reset_players_counter, :only => :index
  
  def index
    if !@ok
      redirect_to '/dashboard'
    else
      @is_back = (!params[:back].nil? && !params[:back].empty?)
      @with_token = !params[:token].nil? && !params[:token].empty?
      @back = params[:back]
    end
  end
  
  def playlist
    @playlist = current_user.playlist
    if @playlist.count == 0
      redirect_to '/dashboard'
    end
  end
  
  private
  
  def skip_authenticate_user_if_token
    initialize_lesson
    update_ok(@lesson.is_public || (logged_in? && session[:user_id].to_i == @lesson.user_id)) if @ok && @lesson.token != params[:token]
  end
  
end
