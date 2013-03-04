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
  
  def send_notifications
    
  end
  
  def reports
    @elements_reports = Report.order('created_at DESC').where(reportable_type: 'MediaElement')
    @lessons_reports = Report.order('created_at DESC').where(reportable_type: 'Lesson')
  end

end
