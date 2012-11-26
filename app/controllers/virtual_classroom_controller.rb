class VirtualClassroomController < ApplicationController
  
  FOR_PAGE = CONFIG['lessons_for_page_in_virtual_classroom']
  LESSONS_IN_QUICK_LOADER = CONFIG['lessons_in_quick_loader']
  
  before_filter :initialize_lesson, :only => [:add_lesson, :remove_lesson, :remove_lesson_from_inside]
  before_filter :initialize_lesson_destination, :only => [:add_lesson, :remove_lesson]
  before_filter :initialize_layout, :initialize_paginator, :only => [:index]
  before_filter :initialize_virtual_classroom_lesson, :only => [:add_lesson_to_playlist, :remove_lesson_from_playlist, :change_position_in_playlist]
  before_filter :initialize_position, :only => :change_position_in_playlist
  before_filter :initialize_lesson_if_in_virtual_classroom, :only => :send_link
  before_filter :initialize_mails, :only => :send_link
  layout 'virtual_classroom'
  
  def index
    get_lessons
    if @page > @pages_amount && @pages_amount != 0
      @page = @pages_amount
      get_lessons
    end
    @playlist = @current_user.playlist
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
      if @virtual_classroom_lesson.add_to_playlist
        @playlist = @current_user.playlist
      else
        @ok = false
        @error = @virtual_classroom_lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problems_adding_to_playlist')
    end
  end
  
  def remove_lesson_from_playlist
    if @ok
      if @virtual_classroom_lesson.remove_from_playlist
        @playlist = @current_user.playlist
      else
        @ok = false
        @error = @virtual_classroom_lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problems_removing_from_playlist')
    end
  end
  
  def change_position_in_playlist
    if @ok
      if !@virtual_classroom_lesson.change_position(@position)
        @ok = false
        @error = @virtual_classroom_lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problems_changing_position_in_playlist')
    end
    @playlist = @current_user.playlist
  end
  
  def empty_playlist
    @ok = @current_user.empty_playlist
    @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problems_emptying_playlist') if !@ok
  end
  
  def empty_virtual_classroom
    @current_user.empty_virtual_classroom
    redirect_to :action => :index
  end
  
  def select_lessons
    @lessons = @current_user.own_lessons(1, LESSONS_IN_QUICK_LOADER)[:records]
  end
  
  def load_lessons
    redirect_to :action => :index
  end
  
  def send_link
    if @ok
      UserMailer.see_my_lesson(@emails, @current_user, @lesson, @message).deliver
      notification = t('descriptions.you_sent_the_link_of_lesson').gsub('#title', "\"#{@lesson.title}\"").gsub('#message', "\"#{@message}\"")
      @emails.each do |em|
        notification = "#{notification} '#{em}',"
      end
      notification.chop!
      Notification.send_to @current_user.id, notification.html_safe
    end
  end
  
  private
  
  def initialize_mails
    @emails = []
    params[:emails].split(',').each do |email|
      flag = false
      x = email.split('@')
      if x.length == 2
        x = x[1].split('.')
        if x.length > 1
          flag = true if x.last.length < 2
        else
          flag = true
        end
      else
        flag = true
      end
      @emails << email
      update_ok(!flag)
    end
    @message = params[:message]
    update_ok(@emails.any? && !@message.blank?)
  end
  
  def initialize_virtual_classroom_lesson
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @virtual_classroom_lesson = VirtualClassroomLesson.where(:lesson_id => @lesson_id, :user_id => @current_user.id).first
    update_ok(!@virtual_classroom_lesson.nil?)
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
