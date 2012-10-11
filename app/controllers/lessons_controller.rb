class LessonsController < ApplicationController
  
  FOR_PAGE = CONFIG['compact_lesson_pagination']
  
  def index
    initialize_paginator
    resp = @current_user.own_lessons(@page, @for_page, @filter)
    @lessons = resp[:content]
    @last_page = resp[:last_page]
    @lessons.each do |l|
      l.set_status @current_user.id
    end
  end
  
  private
  
  def initialize_paginator
    @page = (params[:page].blank? || params[:page].to_i <= 0) ? 1 : params[:page].to_i
    @for_page = FOR_PAGE
    @filter = params[:filter]
    @filter = Filters::ALL_LESSONS if !Filters::LESSONS_SET.include?(@filter)
  end
  
end
