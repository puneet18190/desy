class VirtualClassroomController < ApplicationController
  
  FOR_PAGE = SETTINGS['lessons_for_page_in_virtual_classroom']
  LESSONS_IN_QUICK_LOADER = SETTINGS['lessons_in_quick_loader']
  
  before_filter :initialize_lesson, :only => [:add_lesson, :remove_lesson, :remove_lesson_from_inside]
  before_filter :initialize_lesson_destination, :only => [:add_lesson, :remove_lesson]
  before_filter :initialize_layout, :initialize_paginator, :only => [:index]
  before_filter :initialize_virtual_classroom_lesson, :only => [:add_lesson_to_playlist, :remove_lesson_from_playlist, :change_position_in_playlist]
  before_filter :initialize_position, :only => :change_position_in_playlist
  before_filter :initialize_lesson_for_sending_link, :only => :send_link
  before_filter :initialize_emails, :only => :send_link
  before_filter :initialize_page, :only => :select_lessons_new_block
  before_filter :initialize_loaded_lessons, :only => :load_lessons
  layout 'virtual_classroom'
  
  def index
    get_lessons
    if @page > @pages_amount && @pages_amount != 0
      @page = @pages_amount
      get_lessons
    end
    @playlist = current_user.playlist
    @mailing_list_groups = current_user.own_mailing_list_groups
    @emptier = current_user.own_lessons(1, LESSONS_IN_QUICK_LOADER)[:records].empty?
    render_js_or_html_index
  end
  
  def add_lesson
    if @ok
      if !@lesson.add_to_virtual_classroom(current_user.id)
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
      if !@lesson.remove_from_virtual_classroom(current_user.id)
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
      if !@lesson.remove_from_virtual_classroom(current_user.id)
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
        @playlist = current_user.playlist
      else
        @ok = false
        @error = @virtual_classroom_lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problem_adding_to_playlist')
    end
  end
  
  def remove_lesson_from_playlist
    if @ok
      if @virtual_classroom_lesson.remove_from_playlist
        @playlist = current_user.playlist
      else
        @ok = false
        @error = @virtual_classroom_lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problem_removing_from_playlist')
    end
  end
  
  def change_position_in_playlist
    if @ok
      if !@virtual_classroom_lesson.change_position(@position)
        @ok = false
        @error = @virtual_classroom_lesson.get_base_error
      end
    else
      @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problem_changing_position_in_playlist')
    end
    @playlist = current_user.playlist
  end
  
  def empty_playlist
    @ok = current_user.empty_playlist
    @error = I18n.t('activerecord.errors.models.virtual_classroom_lesson.problem_emptying_playlist') if !@ok
  end
  
  def empty_virtual_classroom
    current_user.empty_virtual_classroom
  end
  
  def select_lessons
    x = current_user.own_lessons(1, LESSONS_IN_QUICK_LOADER)
    @lessons = x[:records]
    @tot_pages = x[:pages_amount]
  end
  
  def select_lessons_new_block
    @lessons = current_user.own_lessons(@page, LESSONS_IN_QUICK_LOADER)[:records] if @ok
  end
  
  def load_lessons
    @loaded = 0
    @load_lessons.each do |l|
      @loaded += 1 if l.add_to_virtual_classroom(current_user.id)
    end
    initialize_paginator
    get_lessons
  end
  
  def send_link
    if @ok
      UserMailer.see_my_lesson(@emails, current_user, @lesson, @message, request.host, request.port).deliver
      string_emails = ''
      @emails.each do |em|
        string_emails = "#{string_emails} '#{em}',"
      end
      string_emails.chop!
      Notification.send_to current_user.id, t('notifications.lessons.link_sent', :title => @lesson.title, :message => @message, :emails => string_emails)
    end
  end
  
  private
  
  def initialize_lesson_for_sending_link
    initialize_lesson
    update_ok(@lesson && @lesson.user_id == current_user.id && @lesson.in_virtual_classroom?(current_user.id))
  end
  
  def initialize_loaded_lessons
    @load_lessons = []
    param_name = 'virtual_classroom_quick_loaded_lesson_name'
    params.each do |k, v|
      k_last = k.split('_').last
      if k.gsub("_#{k_last}", '') == param_name && correct_integer?(k_last) && v == '1'
        lesson = Lesson.find_by_id(k_last.to_i)
        @load_lessons << lesson if !lesson.nil?
      end
    end
  end
  
  def initialize_page
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 0
    update_ok(@page > 0)
  end
  
  def initialize_emails
    emails_hash = {}
    @original_emails_number = params[:emails].split(',').length
    params[:emails].split(',').each do |email|
      emails_hash[email] = true if !(/^([0-9a-zA-Z].*?@([0-9a-zA-Z].*\.\w{2,4}))$/ =~ email).nil?
    end
    @emails = emails_hash.keys
    @message = params[:message_placeholer].blank? ? '' : params[:message]
    @message = @message.blank? ? I18n.t('virtual_classroom.send_link.empty_message') : @message[0, I18n.t('language_parameters.notification.message_length_for_send_lesson_link')]
    update_ok(@emails.any?)
  end
  
  def initialize_virtual_classroom_lesson
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @virtual_classroom_lesson = VirtualClassroomLesson.where(:lesson_id => @lesson_id, :user_id => current_user.id).first
    update_ok(!@virtual_classroom_lesson.nil?)
  end
  
  def get_lessons
    current_user_virtual_classroom_lessons = current_user.full_virtual_classroom(@page, @for_page)
    @lessons = current_user_virtual_classroom_lessons[:records]
    @pages_amount = current_user_virtual_classroom_lessons[:pages_amount]
  end
  
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
  end
  
end
