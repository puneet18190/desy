class Admin::MessagesController < AdminController
  
  layout 'admin'
  
  def new_notification
    
    @locations = [Location.roots]
    if params[:search]
      location = Location.get_from_chain_params params[:search]
      @locations = location.get_filled_select if location
    end
    
    if params[:users] #list of recipients
      @users = []
      @users_ids = params[:users].gsub(/[\[\]\"]/,'').split(',')
      @users_ids.each do |user_id|
        @users << User.find(user_id)
      end
    end
  end
  
  def send_notifications
    if params[:message].present?
      msg = params[:message]
      if params[:all_users]
        User.all.each do |user|
          Notification.send_to(user.id, msg)
        end
      else
        if params[:notification_ids]
          params[:notification_ids].split(',').each do |user_id|
            Notification.send_to(user_id, msg)
          end
        else
          @errors = "errors to add"##TODO
          logger.info "\n\n\n\n #{@errors} \n\n\n\n"
        end
      end
    else
      @errors = "message required"##TODO
      logger.info "\n\n\n\n message error: #{@errors} \n\n\n\n"
    end
    redirect_to :back
  end
  
  def filter_users
    if params[:search].present?
      @users_count = AdminSearchForm.search_notifications_users(params[:search])
    end
  end
  
  def reports
    @elements_reports = Report.order('created_at DESC').where(reportable_type: 'MediaElement')
    @lessons_reports = Report.order('created_at DESC').where(reportable_type: 'Lesson')
  end
  
end
