class RegistrationsController < ApplicationController
  
  before_filter :redirect_to_dashboard, :only => :prelogin
  before_filter :initialize_layout, :only => :edit
  skip_before_filter :require_login
  layout 'registrations'
  
  def prelogin
    render :layout => 'prelogin'
  end
  
  def edit
    render :layout => 'application'
  end
  
  def update
  end
  
  private
  
  def redirect_to_dashboard
    if session[:user_id]
      redirect_to '/dashboard'
      return
    end
  end 
  
end
