class DashboardController < ApplicationController
  
  LESSONS_FOR_PAGE = CONFIG['lessons_for_page_in_dashboard']
  LESSON_PAGES = CONFIG['lesson_pages_in_dashboard']
  ELEMENTS_FOR_PAGE = CONFIG['elements_for_page_in_dashboard']
  ELEMENT_PAGES = CONFIG['element_pages_in_dashboard']
  
  def index
    @lessons = @current_user.suggested_lessons(LESSONS_FOR_PAGE * LESSON_PAGES)
    @media_elements = @current_user.suggested_elements(ELEMENTS_FOR_PAGE * ELEMENT_PAGES)
    @notifications = Notification.where(:user_id => @current_user.id).order('created_at DESC')
    @alert_notifications = Notification.where(:user_id => @current_user.id, :seen => false).any?
    @where = 'dashboard'
  end
  
end
