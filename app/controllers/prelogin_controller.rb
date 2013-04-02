class PreloginController < ApplicationController
  
  skip_before_filter :authenticate
  before_filter :redirect_to_dashboard_if_logged_in
  
  layout proc{ |controller| controller.action_name == 'home' ? 'home' : 'prelogin' }
  
  def home
  end
  
  def registration
    @user             = User.new(params[:user])
    @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
    @locations        = [Location.roots]
    @user_location    = {}
    @subjects         = Subject.order(:description)
  end
  
  def what_is_desy
  end
  
  private
  
  def redirect_to_dashboard_if_logged_in # :doc:
    if logged_in?
      redirect_to dashboard_path
      return
    end
  end
  
end
