class VirtualClassroomController < ApplicationController
  
  FOR_PAGE = CONFIG['lessons_for_page_in_virtual_classroom']
  PLAYLIST_CONTENT = CONFIG['playlist_lessons_loaded_together']
  
  before_filter :initialize_lesson, :only => [:add_lesson, :remove_lesson, :remove_lesson_from_inside]
  before_filter :initialize_lesson_destination, :only => [:add_lesson, :remove_lesson]
  before_filter :initialize_layout, :initialize_paginator, :only => :index
  before_filter :initialize_virtual_classroom_lesson, :only => :add_lesson_to_playlist
  layout 'virtual_classroom'
  
  def index
    get_lessons
    if @page > @pages_amount && @pages_amount != 0
      @page = @pages_amount
      get_lessons
    end
    @playlist = @current_user.playlist_visible_block 0, PLAYLIST_CONTENT
    render_js_or_html_index
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
    prepare_lesson_for_js
    if [ButtonDestinations::FOUND_LESSON, ButtonDestinations::COMPACT_LESSON].include? @destination
      render 'lessons/reload_compact.js'
    else
      render 'lessons/reload_expanded.js'
    end
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
    prepare_lesson_for_js
    if [ButtonDestinations::FOUND_LESSON, ButtonDestinations::COMPACT_LESSON].include? @destination
      render 'lessons/reload_compact.js'
    else
      render 'lessons/reload_expanded.js'
    end
  end
  
  def remove_lesson_from_inside
    if @ok
      if !@lesson.remove_from_virtual_classroom(@current_user.id)
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_removing_from_virtual_classroom')
    end
    render :json => {:ok => @ok, :msg => @error}
  end
  
  def add_lesson_to_playlist
    if @ok
      if !@virtual_classroom_lesson.add_to_playlist
        @ok = false
        @error = @virtual_classroom_lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problems_adding_to_playlist')
    end
    @playlist = @current_user.playlist_visible_block 0, PLAYLIST_CONTENT
  end
  
  private
  
  def initialize_virtual_classroom_lesson
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @virtual_classroom_lesson = VirtualClassroomLesson.where(:lesson_id => @lesson_id, :user_id => @current_user.id).first
    @ok = !@virtual_classroom_lesson.nil?
  end
  
  def get_lessons
    current_user_virtual_classroom_lessons = @current_user.full_virtual_classroom(@page, @for_page)
    @lessons = current_user_virtual_classroom_lessons[:records]
    @pages_amount = current_user_virtual_classroom_lessons[:pages_amount]
  end
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
  end
  
end
