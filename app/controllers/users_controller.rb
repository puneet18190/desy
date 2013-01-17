class UsersController < ApplicationController
  
  before_filter :initialize_layout, :only => [:edit, :subjects, :statistics]
  
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
    @my_liked_lessons    = Statistics.my_liked_lessons(3)
    @all_liked_lessons   = Statistics.all_liked_lessons(3)
  end
  
end
