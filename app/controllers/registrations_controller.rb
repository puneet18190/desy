class RegistrationsController < ApplicationController
  
  before_filter :redirect_to_dashboard, :only => :prelogin
  skip_before_filter :require_login
  layout 'registrations'
  
  def prelogin
    render :layout => 'prelogin'
  end
  
  private
  
  def redirect_to_dashboard
    if session[:user_id]
      redirect_to '/dashboard'
      return
    end
  end 
  
end
