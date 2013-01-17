class UsersController < ApplicationController
  
  before_filter :initialize_layout, :only => [:edit, :subjects, :statistics]
  before_filter :set_statistics_user, :only => :statistics
  skip_before_filter :authenticate, :only => :logout
  
  def edit
  end
  
  def subjects
  end
  
  def statistics
    @my_created_lessons = Statistics.my_created_lessons
    @my_created_elements = Statistics.my_created_elements
  end
  
  def update
  end
  
  def logout
    session[:user_id] = nil
    redirect_to '/'
  end
  
  private 
  
  def set_statistics_user
    Statistics.user = @current_user
  end
  
end
