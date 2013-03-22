class Admin::ReportsController < AdminController
  
  layout 'admin'
  
  def accept
    @ok = correct_integer? params[:id]
    if @ok
      @report = Report.find_by_id params[:id]
      @report.accept if @report
    end
  end
  
  def decline
    @ok = correct_integer? params[:id]
    if @ok
      @report = Report.find_by_id params[:id]
      @report.decline if @report
    end
  end
  
end
