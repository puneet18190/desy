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
    redirect_to_dashboard_if_logged_in
  end
  
  def what_is_desy
    redirect_to_dashboard_if_logged_in
  end
  
  def contact_us
    redirect_to_dashboard_if_logged_in
  end
  
  def login
    # FIXME provvisorio
    login_hash = {
      CONFIG['admin_email'] => 'desymorgan$$',
      'toostrong@morganspa.com' => 'bellaperme',
      'fupete@morganspa.com' => 'bellaperte',
      'jeg@morganspa.com' => 'bellaperlui',
      'holly@morganspa.com' => 'bellapernoi',
      'benji@morganspa.com' => 'bellapervoi',
      'retlaw@morganspa.com' => 'bellaperloro'
    }
    if params[:email].blank? || params[:password].blank?
      @error = t('captions.fill_all_login_fields')
      render 'login_error.js'
      return
    end
    if !login_hash.has_key?(params[:email]) || login_hash[params[:email]] != params[:password] || User.find_by_email(params[:email]).nil?
      @error = t('captions.password_or_username_not_correct')
      render 'login_error.js'
      return
    end
    session[:user_id] = User.find_by_email(params[:email]).id
    # FINO A QUI
    @redirect = session[:prelogin_request]
    session[:prelogin_request] = nil
    @redirect = '/dashboard' if @redirect.blank?
    render 'login_ok.js'
  end
  
  private
  
  def redirect_to_dashboard_if_logged_in
    if logged_in?
      redirect_to '/dashboard'
      return
    end
  end
  
end
