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
    initialize_lesson
    if @ok
      if !@current_user.bookmark('Lesson', @lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_lesson')
      end
    else
      @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_lesson')
    end
    reload_lesson
  end
  
  def copy
    initialize_lesson
    if @ok
      @new_lesson = @lesson.copy(@current_user.id)
      if @new_lesson.nil?
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_copying')
    end
  end
  
  def destroy # qui ci vuole un bel filtro
    initialize_lesson
    if @ok
      if !@lesson.destroy_with_notifications
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_destroying')
    end
  end
  
  def dislike # qui ci vuole un filtro
    initialize_lesson
    if @ok
      if !@current_user.dislike(@lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.like.problem_destroying')
      end
    else
      @error = I18n.t('activerecord.errors.models.like.problem_destroying')
    end
    reload_lesson
  end
  
  def like
    initialize_lesson
    if @ok
      if !@current_user.like(@lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.like.problem_creating')
      end
    else
      @error = I18n.t('activerecord.errors.models.like.problem_creating')
    end
    reload_lesson
  end
  
  def publish # filtro
    initialize_lesson
    if @ok
      if !@lesson.publish
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_publishing')
    end
    reload_lesson
  end
  
  def unpublish # filtro
    initialize_lesson
    if @ok
      if !@lesson.unpublish
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_unpublishing')
    end
    reload_lesson
  end
  
  def remove # filtro
    initialize_lesson
    if @ok
      bookmark = Bookmark.where(:user_id => @current_user.id, :bookmarkable_type => 'Lesson', :bookmarkable_id => @lesson_id).first
      if bookmark.nil?
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_lesson')
      else
        bookmark.destroy
        if Bookmark.where(:user_id => @current_user.id, :bookmarkable_type => 'Lesson', :bookmarkable_id => @lesson_id).any?
          @ok = false
          @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_lesson')
        end
      end
    else
      @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_lesson')
    end
    reload_lesson
  end
  
  private
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
    @filter = params[:filter]
    @filter = Filters::ALL_LESSONS if !Filters::LESSONS_SET.include?(@filter)
  end
  
end
