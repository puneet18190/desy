class DashboardController < ApplicationController
  
  LESSONS_FOR_PAGE = CONFIG['lessons_for_page_in_dashboard']
  LESSON_PAGES = CONFIG['lesson_pages_in_dashboard']
  ELEMENTS_FOR_PAGE = CONFIG['media_elements_for_page_in_dashboard']
  ELEMENT_PAGES = CONFIG['media_element_pages_in_dashboard']
  
  def index
    @lessons = @current_user.suggested_lessons(LESSONS_FOR_PAGE * LESSON_PAGES)
    @lessons.each do |l|
      l.set_status @current_user.id
    end
    @media_elements = @current_user.suggested_elements(ELEMENTS_FOR_PAGE * ELEMENT_PAGES)
    @media_elements.each do |me|
      me.set_status @current_user.id
    end
    @notifications = Notification.where(:user_id => @current_user.id).order('created_at DESC')
    @new_notifications = Notification.where(:user_id => @current_user.id, :seen => false).count
    @where = 'dashboard'
  end
  
end
