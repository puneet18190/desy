class Admin::DashboardController < AdminController

  layout 'admin'
  def index
    @users = User.order('created_at DESC').limit(5)
    @elements_reports = Report.order('created_at DESC').where(reportable_type: 'MediaElement').limit(5)
    @lessons_reports = Report.order('created_at DESC').where(reportable_type: 'Lesson').limit(5)
    
    @all_liked_lessons   = Statistics.all_liked_lessons(3)
    @all_shared_elements = Statistics.all_shared_elements
    @all_shared_lessons  = Statistics.all_shared_lessons
    @all_users           = Statistics.all_users
    @all_users_like      = Statistics.all_users_like
    @all_subjects_chart  = Statistics.all_subjects_chart[0].split(',')
    @all_subjects_desc   = Statistics.all_subjects_chart[1].split(',')
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @elements }
    end
  end
  
end