class PreloginController < ApplicationController
  
  skip_before_filter :authenticate
  layout Proc.new { |controller| controller.action_name == 'home' ? 'home' : 'prelogin' }
  
  def home
    if logged_in?
      redirect_to '/dashboard'
      return
    end
  end
  
  def registration
    if logged_in?
      redirect_to '/profile'
      return
    end
  end
  
  def create_registration
  end
  
  def login
    session[:user_id] = User.find_by_email(CONFIG['admin_email']).id # FIXME TEMPORANEO
    redirect_to '/dashboard'
  end
  
end
