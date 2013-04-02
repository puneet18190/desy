class LessonsController < ApplicationController
  
  FOR_PAGE = SETTINGS['compact_lesson_pagination']
  
  before_filter :check_available_for_user, :only => [:copy, :publish]
  before_filter :initialize_lesson, :only => [:add, :copy, :like, :remove, :dislike]
  before_filter :initialize_lesson_with_owner, :only => [:destroy, :publish, :unpublish, :dont_notify_modification, :notify_modification]
  before_filter :initialize_layout, :initialize_paginator, :only => :index
  before_filter :initialize_lesson_destination, :only => [:add, :copy, :like, :remove, :dislike, :destroy, :publish, :unpublish]
  
  def index
    get_own_lessons
    if @page > @pages_amount && @pages_amount != 0
      @page = @pages_amount
      get_own_lessons
    end
    render_js_or_html_index
  end
  
  def add
    @ok_msg = t('other_popup_messages.correct.add.lesson')
    if @ok
      if !current_user.bookmark('Lesson', @lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_lesson')
      end
    else
      @error = I18n.t('activerecord.errors.models.bookmark.problem_creating_for_lesson')
    end
    if @destination == ButtonDestinations::FOUND_LESSON
      prepare_lesson_for_js
      render 'lessons/reload_compact.js'
    else
      render :json => {:ok => @ok, :msg => (@ok ? @ok_msg : @error)}
    end
  end
  
  def copy
    if @ok
      @new_lesson = @lesson.copy(current_user.id)
      if @new_lesson.nil?
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_copying')
    end
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
    render :json => {:ok => @ok, :msg => @error}
  end
  
  def dislike
    if @ok
      if !current_user.dislike(@lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.like.problem_destroying')
      end
    else
      @error = I18n.t('activerecord.errors.models.like.problem_destroying')
    end
    prepare_lesson_for_js
    if [ButtonDestinations::FOUND_LESSON, ButtonDestinations::COMPACT_LESSON].include? @destination
      render 'lessons/reload_compact.js'
    else
      render 'lessons/reload_expanded.js'
    end
  end
  
  def like
    if @ok
      if !current_user.like(@lesson_id)
        @ok = false
        @error = I18n.t('activerecord.errors.models.like.problem_creating')
      end
    else
      @error = I18n.t('activerecord.errors.models.like.problem_creating')
    end
    prepare_lesson_for_js
    if [ButtonDestinations::FOUND_LESSON, ButtonDestinations::COMPACT_LESSON].include? @destination
      render 'lessons/reload_compact.js'
    else
      render 'lessons/reload_expanded.js'
    end
  end
  
  def publish
    @ok_msg = t('other_popup_messages.correct.publish')
    if @ok
      if !@lesson.publish
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_publishing')
    end
    prepare_lesson_for_js
    if [ButtonDestinations::FOUND_LESSON, ButtonDestinations::COMPACT_LESSON].include? @destination
      render 'lessons/reload_compact.js'
    else
      render 'lessons/reload_expanded.js'
    end
  end
  
  def unpublish
    @ok_msg = t('other_popup_messages.correct.unpublish')
    if @ok
      if !@lesson.unpublish
        @ok = false
        @error = @lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.lesson.problem_unpublishing')
    end
    prepare_lesson_for_js
    if [ButtonDestinations::FOUND_LESSON, ButtonDestinations::COMPACT_LESSON].include? @destination
      render 'lessons/reload_compact.js'
    else
      render 'lessons/reload_expanded.js'
    end
  end
  
  def remove
    @ok_msg = t('other_popup_messages.correct.remove.lesson')
    if @ok
      bookmark = Bookmark.where(:user_id => current_user.id, :bookmarkable_type => 'Lesson', :bookmarkable_id => @lesson_id).first
      if bookmark.nil?
        @ok = false
        @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_lesson')
      else
        bookmark.destroy
        if Bookmark.where(:user_id => current_user.id, :bookmarkable_type => 'Lesson', :bookmarkable_id => @lesson_id).any?
          @ok = false
          @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_lesson')
        end
      end
    else
      @error = I18n.t('activerecord.errors.models.bookmark.problem_destroying_for_lesson')
    end
    if @destination == ButtonDestinations::FOUND_LESSON
      prepare_lesson_for_js
      render 'lessons/reload_compact.js'
    else
      render :json => {:ok => @ok, :msg => (@ok ? @ok_msg : @error)}
    end
  end
  
  def notify_modification
    if @ok
      msg = params[:details_placeholder].blank? ? '' : params[:details]
      @lesson.notify_changes msg
    end
  end
  
  def dont_notify_modification
    if @ok
      @lesson.dont_notify_changes
      render :nothing => true
    end
  end
  
  private
  
  def check_available_for_user # :doc:
    l = Lesson.find_by_id params[:lesson_id]
    if l && !l.available?
      render :nothing => true
      return
    end
  end
  
  def get_own_lessons # :doc:
    current_user_own_lessons = current_user.own_lessons(@page, @for_page, @filter)
    @lessons = current_user_own_lessons[:records]
    @pages_amount = current_user_own_lessons[:pages_amount]
  end
  
  def initialize_paginator # :doc:
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
    @filter = params[:filter]
    @filter = Filters::ALL_LESSONS if !Filters::LESSONS_SET.include?(@filter)
  end
  
end
