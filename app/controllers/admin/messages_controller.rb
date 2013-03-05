class Admin::MessagesController < AdminController
  layout 'admin'

  def contact
    if params[:users] #list of recipients
      @users = []
      @users_ids = params[:users].gsub(/[\[\]]/,'').split(',')
      @users_ids.each do |user_id|
        @users << User.find(user_id)
      end
    end
  end
  
  def new_notification
    @location_root = Location.roots
  end
  
  def send_notifications
    if params[:all_users] && params[:message].present?
      User.all.each do |user|
        Notification.send_to(user.id, msg)
      end
    else
      
      if params[:notification_ids] && params[:message]
        msg = params[:message]
        params[:notification_ids].split(',').each do |user_id|
          Notification.send_to(user_id, msg)
        end
      else
        @errors = "errors to add"
      end
      
    end
    redirect_to :back
  end
  
  def filter_users
    @users = User.all
    if false
      @users = AdminSearchForm.search(params[:search],'users')
    end
  end
  
  def reports
    @elements_reports = Report.order('created_at DESC').where(reportable_type: 'MediaElement')
    @lessons_reports = Report.order('created_at DESC').where(reportable_type: 'Lesson')
  end

end
