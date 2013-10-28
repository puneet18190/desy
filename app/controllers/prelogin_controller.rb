# == Description
#
# Contains the actions called while the user is not logged in
#
# == Models used
#
# * User
# * SchoolLevel
# * Location
# * Subject
#
class PreloginController < ApplicationController
  
  skip_before_filter :authenticate
  before_filter :redirect_to_dashboard_if_logged_in
    
  # === Description
  #
  # Home page of the application
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#authenticate
  #
  # === Skipped filters
  #
  # * PreloginController#redirect_to_dashboard_if_logged_in
  #
  def home
  end
  
  # === Description
  #
  # Form to sign in
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#authenticate
  #
  # === Skipped filters
  #
  # * PreloginController#redirect_to_dashboard_if_logged_in
  #
  def registration
    @user             = User.new(params[:user])
    @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
    @locations        = [{:selected => 0, :content => Location.roots}]
    @user_location    = {}
    @subjects         = Subject.order(:description)
  end
  
  # === Description
  #
  # Section of the main page
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#authenticate
  #
  # === Skipped filters
  #
  # * PreloginController#redirect_to_dashboard_if_logged_in
  #
  def what_is
  end
  
  private
  
  # If the user is logged in, redirects to DashboardController#index
  def redirect_to_dashboard_if_logged_in
    if logged_in?
      redirect_to dashboard_path
      return
    end
  end
  
end
