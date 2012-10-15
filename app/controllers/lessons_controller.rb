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
  
  def add
    @ok = correct_integer? params[:lesson_id]
    @ok = @current_user.bookmark('Lesson', params[:lesson_id].to_i) if @ok
    @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_lesson') if !@ok
  end
  
  private
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
    @filter = params[:filter]
    @filter = Filters::ALL_LESSONS if !Filters::LESSONS_SET.include?(@filter)
  end
  
end
