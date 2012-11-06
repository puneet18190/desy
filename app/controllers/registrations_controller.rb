class RegistrationsController < ApplicationController
  
  before_filter :initialize_layout, :only => :edit
  skip_before_filter :authenticate, :only => [:login, :prelogin]
  layout 'registrations'
  
  def prelogin
    if session[:user_id].class == Fixnum && User.exists?(session[:user_id])
      redirect_to '/dashboard'
      return
    end
    render :layout => 'prelogin'
  end
  
  def edit
    render :layout => 'application'
  end
  
  def update
  end
  
  def logout
    session[:user_id] = nil
    redirect_to '/'
  end
  
  def login
    session[:user_id] = User.find_by_email(CONFIG['admin_email']).id # FIXME TEMPORANEO
    redirect_to '/dashboard'
  end
  
end
