class PreloginController < ApplicationController
  
  skip_before_filter :authenticate
  layout Proc.new { |controller| controller.action_name == 'home' ? 'home' : 'prelogin' }
  
  def home
    redirect_to_dashboard_if_logged_in
  end
  
  def registration
    redirect_to_dashboard_if_logged_in
  end
  
  def create_registration
  end
  
  def what_is_desy
    redirect_to_dashboard_if_logged_in
  end
  
  def contact_us
    redirect_to_dashboard_if_logged_in
  end
  
  def login
  
    if params[:email].blank? || params[:password].blank?
      render 'login_error.js'
      return
    end
    
    session[:user_id] = User.find_by_email(CONFIG['admin_email']).id # FIXME TEMPORANEO
    redirect = session[:prelogin_request]
    session[:prelogin_request] = nil
    if redirect.blank?
      redirect_to '/dashboard'
    else
      redirect_to redirect
    end
  end
  
  private
  
  def redirect_to_dashboard_if_logged_in
    if logged_in?
      redirect_to '/dashboard'
      return
    end
  end
  
end
