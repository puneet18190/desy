class RegistrationsController < ApplicationController
  
  skip_before_filter :require_login
  layout 'registrations'
  
  def prelogin
    render :layout => 'prelogin'
  end
  
end
