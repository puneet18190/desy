class SearchController < ApplicationController
  
  LESSONS_FOR_PAGE = CONFIG['compact_lesson_pagination']
  MEDIA_ELEMENTS_FOR_PAGE = CONFIG['compact_media_element_pagination']
  
  before_filter :initialize_notifications
  
  def lessons
    @lessons = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
  
  def media_elements
    @media_elements = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
  
end
