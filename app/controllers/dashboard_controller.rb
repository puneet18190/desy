class DashboardController < ApplicationController
  
  before_filter :initialize_layout, :initialize_pagination
  
  def index
    @lessons = @current_user.suggested_lessons(@lessons_for_page * @lesson_pages)
    @lessons_emptied = Lesson.dashboard_emptied? @current_user.id
    @media_elements = @current_user.suggested_media_elements(@media_elements_for_page * @media_element_pages)
    @media_elements_emptied = MediaElement.dashboard_emptied? @current_user.id
    @new_media_element = MediaElement.new(params[:media_element])
    render_js_or_html_index
  end
  
  private
  
  def initialize_pagination
    @lessons_for_page = CONFIG['lessons_for_page_in_dashboard']
    @lesson_pages = CONFIG['lesson_pages_in_dashboard']
    @media_elements_for_page = CONFIG['media_elements_for_page_in_dashboard']
    @media_element_pages = CONFIG['media_element_pages_in_dashboard']
  end
  
end
