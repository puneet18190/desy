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
    @my_liked_lessons = Statistics.my_liked_lessons(3)
    @all_liked_lessons = Statistics.all_liked_lessons(3)
    @my_likes_count = Statistics.my_likes_count
    @all_shared_elements = Statistics.all_shared_elements
    @all_shared_lessons = Statistics.all_shared_lessons
    @all_users = Statistics.all_users
    @all_subjects_chart = Statistics.all_subjects_chart[0].split(',')
    @all_subjects_desc = Statistics.all_subjects_chart[1].split(',')
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
