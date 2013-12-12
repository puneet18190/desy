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
    @lessons = current_user.suggested_lessons(@lessons_for_raw * @lesson_raws)
    @lessons_emptied = Lesson.dashboard_emptied? current_user.id
    @media_elements = current_user.suggested_media_elements(@media_elements_for_raw * @media_element_raws)
    @media_elements_emptied = MediaElement.dashboard_emptied? current_user.id
    render_js_or_html_index
  end
  
  private
  
  # Initializes all the parameters of pagination
  def initialize_pagination
    @lessons_for_raw = correct_integer?(params['lessons_for_raw']) ? params['lessons_for_raw'].to_i : 0
    @lesson_raws = 6
    @media_elements_for_raw = correct_integer?(params['media_elements_for_raw']) ? params['media_elements_for_raw'].to_i : 0
    @media_element_raws = 6
    if @lessons_for_raw != 0 && @media_elements_for_raw != 0
      @lesson_raws = 1
      @media_element_raws = 1
    end
    @lessons_for_raw = 0 if @lessons_for_raw > 50
    @media_elements_for_raw = 0 if @media_elements_for_raw > 50
  end
  
end
