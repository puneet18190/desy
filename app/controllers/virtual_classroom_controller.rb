class VirtualClassroomController < ApplicationController
  
  FOR_PAGE = CONFIG['lessons_for_page_in_virtual_classroom']
  PLAYLIST_CONTENT = CONFIG['playlist_lessons_loaded_together']
  
  before_filter :initialize_lesson, :only => [:add_lesson, :remove_lesson]
  before_filter :initialize_layout, :initialize_paginator, :only => :index
  layout 'virtual_classroom'
  
  def index
    get_lessons
    if @last_page && (@page != 1) && @lessons.empty?
      @page = 1
      get_lessons
    end
    @playlist = @lessons
  end
  
  def add_lesson
    if @ok
      if !@lesson.add_to_virtual_classroom(@current_user.id)
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_adding_to_virtual_classroom')
    end
    respond_standard_js
  end
  
  def remove_lesson
    if @ok
      if !@lesson.remove_from_virtual_classroom(@current_user.id)
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_removing_from_virtual_classroom')
    end
    respond_standard_js
  end
  
  private
  
  def get_lessons
    resp = @current_user.full_virtual_classroom(@page, @for_page)
    @lessons = resp[:content]
    @last_page = resp[:last_page]
  end
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
  end
  
end
