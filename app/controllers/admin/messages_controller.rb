# == Description
#
# Controller of notifications and general messages in the administration section. See AdminController.
#
# == Models used in this controller
#
# * Location
# * Notification
# * Report
# * User
# * AdminSearchForm
#
class Admin::MessagesController < AdminController
  
  layout 'admin'
  
  # === Description
  #
  # Main page of the multiple notification sender
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # ApplicationController#admin_authentication
  #
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
  
  # === Description
  #
  # Ajax action that updates the number of recipients in the multiple notification sender main page
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # ApplicationController#admin_authentication
  #
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
  
  # === Description
  #
  # Main page of the reports (for actions related to reports, see Admin::ReportsController)
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # ApplicationController#admin_authentication
  #
  def reports
    @elements_reports = Report.order('created_at DESC').where(:reportable_type => 'MediaElement').page(params[:elements_page])
    @lessons_reports = Report.order('created_at DESC').where(:reportable_type => 'Lesson').page(params[:lessons_page])
  end
  
  private
  
  def send_notifications(users_ids, message) # :doc:
    Notification.send_to(users_ids, message)
  end
  
end
