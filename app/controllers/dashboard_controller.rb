# == Description
#
# Controller for the dashboard
#
# == Models used
#
# * Lesson
# * MediaElement
#
class DashboardController < ApplicationController
  
  before_filter :initialize_layout, :initialize_pagination
  
  # === Description
  #
  # Extracts suggested lessons and elements (see User#suggested_lessons, User#suggested_media_elements)
  #
  # === Mode
  #
  # Html + Ajax
  #
  # === Specific filters
  #
  # * DashboardController#initialize_pagination
  # * ApplicationController#initialize_layout
  #
  def index
    @lessons = current_user.suggested_lessons(@lessons_for_page * @lesson_pages)
    @lessons_emptied = Lesson.dashboard_emptied? current_user.id
    @media_elements = current_user.suggested_media_elements(@media_elements_for_page * @media_element_pages)
    @media_elements_emptied = MediaElement.dashboard_emptied? current_user.id
    render_js_or_html_index
  end
  
  private
  
  def initialize_pagination # :doc:
    @lessons_for_page = SETTINGS['lessons_for_page_in_dashboard']
    @lesson_pages = SETTINGS['lesson_pages_in_dashboard']
    @media_elements_for_page = SETTINGS['media_elements_for_page_in_dashboard']
    @media_element_pages = SETTINGS['media_element_pages_in_dashboard']
  end
  
end
