class LessonsController < ApplicationController
  
  FOR_PAGE = CONFIG['compact_lesson_pagination']
  
  before_filter :initialize_lesson, :only => [:add, :copy, :like, :remove, :dislike]
  before_filter :initialize_lesson_with_owner, :only => [:destroy, :publish, :unpublish]
  
  def index
    initialize_paginator
    resp = @current_user.own_lessons(@page, @for_page, @filter)
    @lessons = resp[:content]
    @last_page = resp[:last_page]
    if @last_page && (@page != 1) && @lessons.empty?
      @page = 1
      resp = @current_user.own_lessons(@page, @for_page, @filter)
      @lessons = resp[:content]
      @last_page = resp[:last_page]
    end
    @lessons.each do |l|
      l.set_status @current_user.id
    end
  end
  
  def add
    if @ok
      if !@current_user.bookmark('Lesson', @lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_lesson')
      end
    else
      @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_lesson')
    end
    respond_standard_js @destination
  end
  
  def copy
    if @ok
      @new_lesson = @lesson.copy(@current_user.id)
      if @new_lesson.nil?
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_copying')
    end
    respond_standard_js @destination
  end
  
  def destroy
    if @ok
      if !@lesson.destroy_with_notifications
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_destroying')
    end
    respond_standard_js @destination
  end
  
  def dislike
    if @ok
      if !@current_user.dislike(@lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.like.problem_destroying')
      end
    else
      @error = I18n.t('activerecord.errors.models.like.problem_destroying')
    end
    respond_standard_js @destination
  end
  
  def like
    if @ok
      if !@current_user.like(@lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.like.problem_creating')
      end
    else
      @error = I18n.t('activerecord.errors.models.like.problem_creating')
    end
    respond_standard_js @destination
  end
  
  def publish
    if @ok
      if !@lesson.publish
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_publishing')
    end
    respond_standard_js @destination
  end
  
  def unpublish
    if @ok
      if !@lesson.unpublish
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_unpublishing')
    end
    respond_standard_js @destination
  end
  
  def remove
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
    respond_standard_js @destination
  end
  
  private
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
    @filter = params[:filter]
    @filter = Filters::ALL_LESSONS if !Filters::LESSONS_SET.include?(@filter)
  end
  
end
