class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login
  
  private
  
  def require_login
    @current_user = User.find_by_email(CONFIG['admin_email'])
  end
  
end
