class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate, :initialize_location, :initialize_players_counter
  
  private

  attr_reader :current_user
  helper_method :current_user
  
  def initialize_players_counter
    Dir.mkdir Rails.root.join('tmp') unless Dir.exists? Rails.root.join('tmp')
    if File.exists?(Rails.root.join('tmp/players_counter.yml'))
      file = YAML::load(File.open(Rails.root.join('tmp/players_counter.yml')))
      @video_counter = [file['video_counter'], 1]
      @audio_counter = [file['audio_counter'], 1]
      file['video_counter'] += 1
      file['audio_counter'] += 1
    else
      @video_counter = [1, 1]
      @audio_counter = [1, 1]
      file = {'video_counter' => 2, 'audio_counter' => 2}
    end
    yaml = File.open(Rails.root.join('tmp/players_counter.yml'), 'w')
    yaml.write file.to_yaml
    yaml.close
  end
  
  def reset_players_counter
    @video_counter = [1, 1]
    @audio_counter = [1, 1]
    file = {'video_counter' => 2, 'audio_counter' => 2}
    yaml = File.open(Rails.root.join('tmp/players_counter.yml'), 'w')
    yaml.write file.to_yaml
    yaml.close
  end
  
  def prepare_lesson_for_js
    if !@lesson.nil?
      @lesson = Lesson.find_by_id @lesson.id
      @lesson.set_status current_user.id
    end
  end
  
  def prepare_media_element_for_js
    if !@media_element.nil?
      @media_element = MediaElement.find_by_id @media_element.id
      @media_element.set_status current_user.id
    end
  end
  
  def initialize_lesson_with_owner
    initialize_lesson
    update_ok(@lesson && current_user.id == @lesson.user_id)
  end
  
  def initialize_lesson_if_in_virtual_classroom
    initialize_lesson
    update_ok(@lesson && @lesson.in_virtual_classroom?(current_user.id))
  end
  
  def initialize_lesson
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @lesson = Lesson.find_by_id @lesson_id
    update_ok(!@lesson.nil?)
  end
  
  def initialize_lesson_destination
    @destination = params[:destination]
    update_ok(ButtonDestinations::LESSONS.include?(@destination))
  end
  
  def initialize_media_element_with_owner_or_public
    initialize_media_element
    update_ok(@media_element && (@media_element.is_public || current_user.id == @media_element.user_id))
  end
  
  def initialize_media_element_with_owner_and_private
    initialize_media_element_with_owner
    update_ok(@media_element && !@media_element.is_public)
  end
  
  def initialize_media_element_with_owner
    initialize_media_element
    update_ok(@media_element && current_user.id == @media_element.user_id)
  end
  
  def initialize_media_element
    @media_element_id = correct_integer?(params[:media_element_id]) ? params[:media_element_id].to_i : 0
    @media_element = MediaElement.find_by_id @media_element_id
    update_ok(!@media_element.nil?)
  end
  
  def initialize_media_element_destination
    @destination = params[:destination]
    update_ok(ButtonDestinations::MEDIA_ELEMENTS.include?(@destination))
  end
  
  def initialize_position
    @position = correct_integer?(params[:position]) ? params[:position].to_i : 0
    update_ok(@position > 0)
  end
  
  def initialize_layout
    @delete_item = params[:delete_item]
    if !request.xhr?
      @notifications = current_user.notifications_visible_block 0, CONFIG['notifications_loaded_together']
      @new_notifications = current_user.number_notifications_not_seen
      @offset_notifications = @notifications.length
      @tot_notifications = current_user.tot_notifications_number
    end
  end
  
  def initialize_location
    @where = controller_name
  end
  
  def authenticate
    return redirect_to root_path(redirect_to: request.fullpath) if !logged_in?
  end

  def current_user
    @current_user ||= ( session[:user_id] and User.confirmed.find_by_id(session[:user_id]) )
  end

  def current_user=(user)
    session[:user_id] = user ? user.id : nil
    @current_user = user
  end
  
  def render_js_or_html_index
    render 'index', formats: [request.xhr? ? :js : :html]
  end
  
  def correct_integer?(x)
    x.class == String && (x =~ /\A\d+\Z/) == 0
  end
  
  def update_ok(condition)
    @ok = true if @ok.nil?
    @ok = @ok && condition
  end
  
  def logged_in?
    current_user
  end
  
end
