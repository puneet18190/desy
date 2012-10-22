class DashboardController < ApplicationController
  
  LESSONS_FOR_PAGE = CONFIG['lessons_for_page_in_dashboard']
  LESSON_PAGES = CONFIG['lesson_pages_in_dashboard']
  ELEMENTS_FOR_PAGE = CONFIG['media_elements_for_page_in_dashboard']
  ELEMENT_PAGES = CONFIG['media_element_pages_in_dashboard']
  
  def index
    @lessons = @current_user.suggested_lessons(LESSONS_FOR_PAGE * LESSON_PAGES)
    @lessons_emptied = Lesson.dashboard_emptied? @current_user.id
    @media_elements = @current_user.suggested_media_elements(ELEMENTS_FOR_PAGE * ELEMENT_PAGES)
    @media_elements_emptied = MediaElement.dashboard_emptied? @current_user.id
  end
  
end
