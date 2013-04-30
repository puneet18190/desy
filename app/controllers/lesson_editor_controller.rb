# == Description
#
# Actions for lesson editor.
#
# == Models used
#
# * Lesson
# * Slide
# * Tagging
# * Tag
# * MediaElement
# * MediaElementsSlide
# * Subject
#
class LessonEditorController < ApplicationController
  
  before_filter :check_available_for_user
  before_filter :initialize_lesson_with_owner, :only => [:index, :update, :edit]
  before_filter :initialize_subjects, :only => :new
  before_filter :initialize_lesson_with_owner_and_slide, :only => [
    :add_slide,
    :save_slide,
    :delete_slide,
    :change_slide_position,
    :load_slide,
    :save_slide_and_exit,
    :save_slide_and_edit
  ]
  before_filter :initialize_kind, :only => :add_slide
  before_filter :initialize_position, :only => :change_slide_position
  layout 'lesson_editor'
  
  # === Description
  #
  # Main page of the editor for a specific lesson
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * ApplicationController#initialize_lesson_with_owner
  #
  def index
    if !@ok
      redirect_to '/dashboard'
      return
    else
      @slides = @lesson.slides.order(:position)
      @max_slides = @lesson.reached_the_maximum_of_slides?
    end
  end
  
  # === Description
  #
  # Form to create a new lesson
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_subjects
  #
  def new
  end
  
  # === Description
  #
  # Action that creates a new lesson
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  #
  def create
    title = params[:title_placeholder] != '0' ? '' : params[:title]
    description = params[:description_placeholder] != '0' ? '' : params[:description]
    tags = params[:tags_value]
    new_lesson = current_user.create_lesson title, description, params[:subject], tags
    if new_lesson.instance_of?(Lesson)
      @lesson = new_lesson
    else
      @errors = convert_lesson_editor_messages new_lesson.messages
      @error_fields = new_lesson.keys
    end
  end
  
  # === Description
  #
  # Action that updates general information (title, description, tags, subject) of an existing lesson
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * ApplicationController#initialize_lesson_with_owner
  #
  def update
    if !@ok
      redirect_to '/dashboard'
      return
    else
      @lesson.title = params[:title]
      @lesson.description =  params[:description]
      @lesson.subject_id = params[:lesson_subject]
      @lesson.tags = params[:tags_value]
      @lesson.validating_in_form = true
      if !@lesson.save
        @errors = convert_item_error_messages @lesson.errors.messages
        @error_fields = @lesson.errors.messages.keys
      else
        @lesson.modify
      end
    end
  end
  
  # === Description
  #
  # Form to edit general information (title, description, tags, subject) of an existing lesson
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * ApplicationController#initialize_lesson_with_owner
  #
  def edit
    if !@ok
      redirect_to '/dashboard'
      return
    end
    @my_tags = Tagging.includes(:tag).where(:taggable_type => 'Lesson', :taggable_id => @lesson_id).order(:tag_id)
    @subjects = Subject.order(:description)
  end
  
  # === Description
  #
  # Action that adds a new slide to the lesson
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_lesson_with_owner_and_slide
  # * LessonEditorController#initialize_kind
  #
  def add_slide
    if @ok
      @current_slide = @lesson.add_slide @kind, (@slide.position + 1)
      @slides = @lesson.slides.order(:position)
    end
  end
  
  # === Description
  #
  # Action that saves the current slide without doing anything else
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_lesson_with_owner_and_slide
  #
  def save_slide
    save_current_slide if @ok
  end
  
  # === Description
  #
  # Action that saves the current slide and leaving the editor right after
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_lesson_with_owner_and_slide
  #
  def save_slide_and_exit
    save_current_slide if @ok
  end
  
  # === Description
  #
  # Action that saves the current slide and redirecting to LessonEditorController#edit right after
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_lesson_with_owner_and_slide
  #
  def save_slide_and_edit
    save_current_slide if @ok
  end
  
  # === Description
  #
  # Action that deletes the current slide
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_lesson_with_owner_and_slide
  #
  def delete_slide
    if @ok
      @current_slide = @lesson.slides.where(:position => @slide.position - 1).first
      @slide.destroy_with_positions
      @slides = @lesson.slides.order(:position)
    end
  end
  
  # === Description
  #
  # Action that changes the position of a slide
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_lesson_with_owner_and_slide
  # * ApplicationController#initialize_position
  #
  def change_slide_position
    if @ok
      @replaced_slide = Slide.find_by_lesson_id_and_position(@lesson_id, @position)
      @slide.change_position(@position)
      @slides = @lesson.slides.order(:position)
      @current_slide = @slide
    end
  end
  
  # === Description
  #
  # Action that loads via Ajax a new slide
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * LessonEditorController#check_available_for_user
  # * LessonEditorController#initialize_lesson_with_owner_and_slide
  #
  def load_slide
  end
  
  private
  
  # Checks if the lesson editor is not locked for the user
  def check_available_for_user
    @lesson = Lesson.find_by_id params[:lesson_id]
    if @lesson && !@lesson.available?
      render 'not_available'
      return
    end
  end
  
  # Initializes the kind of a new slide, taking it from the url parameters
  def initialize_kind
    @kind = Slide::KINDS_WITHOUT_COVER.include?(params[:kind]) ? params[:kind] : ''
    update_ok(!@kind.blank?)
  end
  
  # Calls ApplicationController#initialize_lesson_with_owner, and additionally checks if the slide corresponds to the lesson
  def initialize_lesson_with_owner_and_slide
    initialize_lesson_with_owner
    @slide_id = correct_integer?(params[:slide_id]) ? params[:slide_id].to_i : 0
    @slide = Slide.find_by_id @slide_id
    update_ok(@slide && @lesson && @lesson.id == @slide.lesson_id)
  end
  
  # Initializes the subjects
  def initialize_subjects
    @subjects = []
    UsersSubject.joins(:subject).where(:user_id => current_user.id).order('subjects.description ASC').each do |sbj|
      @subjects << sbj.subject
    end
    @subjects
  end
  
  # Saves the current slide, using Slide#update_with_media_elements
  def save_current_slide
    media_elements_params = {}
    (1...5).each do |i|
      if !params["media_element_#{i}"].blank?
        media_element_id = correct_integer?(params["media_element_#{i}"]) ? params["media_element_#{i}"].to_i : 0
        alignment = params["media_element_align_#{i}"].blank? ? nil : params["media_element_align_#{i}"].to_i
        caption = params["caption_#{i}"]
        media_elements_params[i] = [media_element_id, alignment, caption]
      end
    end
    @ok = @slide.update_with_media_elements((params[:title].blank? ? nil : params[:title]), (params[:text].blank? ? nil : params[:text]), media_elements_params)
  end
  
end
