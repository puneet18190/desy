class UsersController < ApplicationController
  
  before_filter :initialize_layout, :only => :edit
  skip_before_filter :authenticate, :only => :logout
  
  def edit
  end
  
  def update
  end
  
  def logout
    session[:user_id] = nil
    redirect_to '/'
  end
  
end
