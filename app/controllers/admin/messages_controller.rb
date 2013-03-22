class Admin::MessagesController < AdminController
  
  layout 'admin'
  
  def new_notification
    @locations = [Location.roots]
    if params[:search]
      location = Location.get_from_chain_params params[:search]
      @locations = location.get_filled_select if location
    end
    if params[:users]
      @users = User.find(params[:users].gsub(/[\[\]\"]/, '').split(','))
    end
  end
  
  def filter_users
    if params[:search].present?
      if params[:send_message].present? && params[:message].present?
        if params[:all_users].present?
          users = :all
        else
          users = AdminSearchForm.search_notifications_users(params[:search]).pluck('users.id')
        end
        if users.present?
          send_notifications(users, params[:message].to_s)
        end
        @reset_form = true
      else
        @users_count = AdminSearchForm.search_notifications_users(params[:search], true)
      end
    end
  end
  
  def reports
    @elements_reports = Report.order('created_at DESC').where(:reportable_type => 'MediaElement').page(params[:elements_page])
    @lessons_reports = Report.order('created_at DESC').where(:reportable_type => 'Lesson').page(params[:lessons_page])
  end
  
  private
  
  def send_notifications(users_ids, message)
    Notification.send_to(users_ids, message)
  end
  
end
