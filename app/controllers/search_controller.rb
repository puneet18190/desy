class SearchController < ApplicationController
  
  before_filter :initialize_notifications # limitarlo alle azioni principali??
  
  def lessons
    @lessons = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
  
  def media_elements
    @media_elements = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end
  
end
