class DashboardController < ApplicationController
  
  def index
    @lessons = Lesson.all
    @media_elements = MediaElement.all
    @notifications = Notification.where(:user_id => @current_user.id)
  end
  
end
