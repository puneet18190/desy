class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_login
  
  private
  
  def require_login
    @current_user = User.find_by_email(CONFIG['admin_email'])
    # TODO questa parte qui sotto andrà preservata anche quando ci sarà la autenticazione vera
    @where = params[:controller]
    @notifications = Notification.where(:user_id => @current_user.id).order('created_at DESC')
    @new_notifications = Notification.where(:user_id => @current_user.id, :seen => false).count
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
end
