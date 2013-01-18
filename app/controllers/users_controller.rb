class UsersController < ApplicationController
  
  skip_before_filter :authenticate, only: :create
  before_filter :initialize_layout, :only => [:edit, :subjects, :statistics]

  def create
    @user = User.new(params[:user])

    _d @user
  end
  
  def edit
  end

  def update
  end
  
  def subjects
  end
  
  def statistics
    Statistics.user = current_user

    @my_created_lessons  = Statistics.my_created_lessons
    @my_created_elements = Statistics.my_created_elements
    @my_copied_lessons = Statistics.my_copied_lessons
    @my_liked_lessons = Statistics.my_liked_lessons(3)
    @all_liked_lessons = Statistics.all_liked_lessons(3)
    @my_likes_count = Statistics.my_likes_count
    @all_shared_elements = Statistics.all_shared_elements
    @all_shared_lessons = Statistics.all_shared_lessons
    @all_users = Statistics.all_users
    @all_users_like = Statistics.all_users_like
    @all_subjects_chart = Statistics.all_subjects_chart[0].split(',')
    @all_subjects_desc = Statistics.all_subjects_chart[1].split(',')
  end
  
  def update
  end
  
  def logout
    session[:user_id] = nil
    redirect_to '/'
  end
  
end
