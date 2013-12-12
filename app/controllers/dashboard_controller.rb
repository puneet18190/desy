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
  
  # Pages of lessons
  LESSON_PAGES = 6
  # Pages of media elements
  MEDIA_ELEMENT_PAGES = 6
  # Rows of lessons in each page
  LESSON_ROWS_PER_PAGE = 2
  # Rows of media elements in each page
  MEDIA_ELEMENT_ROWS_PER_PAGE = 2
  
  # === Description
  #
  # Extracts suggested lessons and elements (see User#suggested_lessons, User#suggested_media_elements). When it's called via ajax it's because of the application of filters, paginations, or after an operation that changed the number of items in the page.
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
    @lessons = current_user.suggested_lessons(@lessons_for_row * @lesson_rows)
    @lessons_emptied = Lesson.dashboard_emptied? current_user.id
    @media_elements = current_user.suggested_media_elements(@media_elements_for_row * @media_element_rows)
    @media_elements_emptied = MediaElement.dashboard_emptied? current_user.id
    render_js_or_html_index
  end
  
  private
  
  # Initializes all the parameters of pagination
  def initialize_pagination
    @lessons_for_row = correct_integer?(params['lessons_for_row']) ? params['lessons_for_row'].to_i : 0
    @lesson_rows = params[:lessons_expanded].present? ? LESSON_PAGES * LESSON_ROWS_PER_PAGE : 1
    @media_elements_for_row = correct_integer?(params['media_elements_for_row']) ? params['media_elements_for_row'].to_i : 0
    @media_element_rows = params[:media_elements_expanded].present? ? MEDIA_ELEMENT_PAGES * MEDIA_ELEMENT_ROWS_PER_PAGE : 1
    @lessons_for_row = 0 if @lessons_for_row > 50
    @media_elements_for_row = 0 if @media_elements_for_row > 50
  end
  
end
