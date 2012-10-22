class RegistrationsController < ApplicationController
  
  skip_before_filter :require_login, :initialize_notifications
  layout 'registrations'
  
  def prelogin
    render :layout => 'prelogin'
  end
  
end
