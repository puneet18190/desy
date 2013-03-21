class LessonEditorController < ApplicationController
  
  before_filter :check_available_for_user
  before_filter :initialize_lesson_with_owner, :only => [:index, :update, :edit]
  before_filter :initialize_subjects, :only => :new
  before_filter :initialize_lesson_with_owner_and_slide, :only => [:add_slide, :save_slide, :delete_slide, :change_slide_position, :load_slide, :save_slide_and_exit]
  before_filter :initialize_kind, :only => :add_slide
  before_filter :initialize_position, :only => :change_slide_position
  layout 'lesson_editor'
  
  def index
    if !@ok
      redirect_to '/dashboard'
      return
    else
      @slides = @lesson.slides.order(:position)
      @max_slides = @lesson.reached_the_maximum_of_slides?
    end
  end
  
  def new
  end
  
  def create
    title = params[:title_placeholder] != '0' ? '' : params[:title]
    description = params[:description_placeholder] != '0' ? '' : params[:description]
    tags = params[:tags_value]
    new_lesson = current_user.create_lesson title, description, params[:subject], tags
    if new_lesson.instance_of?(Lesson)
      @lesson = new_lesson
    else
      @errors = convert_lesson_editor_messages new_lesson
      @error_fields = new_lesson.keys
    end
  end
  
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
        @lesson.modified
      end
    end
  end
  
  def edit
    if !@ok
      redirect_to '/dashboard'
      return
    end
    @my_tags = Tagging.includes(:tag).where(:taggable_type => 'Lesson', :taggable_id => @lesson_id).order(:tag_id)
    @subjects = Subject.order(:description)
  end
  
  def add_slide
    if @ok
      @current_slide = @lesson.add_slide @kind, (@slide.position + 1)
      @slides = @lesson.slides.order(:position)
    end
  end
  
  def save_slide
    save_current_slide if @ok
  end
  
  def save_slide_and_exit
    save_current_slide if @ok
  end
  
  def delete_slide
    if @ok
      @current_slide = @lesson.slides.where(:position => @slide.position - 1).first
      @slide.destroy_with_positions
      @slides = @lesson.slides.order(:position)
    end
  end
  
  def change_slide_position
    if @ok
      @replaced_slide = Slide.find_by_lesson_id_and_position(@lesson_id, @position)
      @slide.change_position(@position)
      @slides = @lesson.slides.order(:position)
      @current_slide = @slide
    end
  end
  
  def load_slide
  end
  
  private
  
  def check_available_for_user
    @lesson = Lesson.find_by_id params[:lesson_id]
    if @lesson && !@lesson.available?
      render 'not_available'
      return
    end
  end
  
  def initialize_kind
    @kind = Slide::KINDS_WITHOUT_COVER.include?(params[:kind]) ? params[:kind] : ''
    update_ok(!@kind.blank?)
  end
  
  def initialize_lesson_with_owner_and_slide
    initialize_lesson_with_owner
    @slide_id = correct_integer?(params[:slide_id]) ? params[:slide_id].to_i : 0
    @slide = Slide.find_by_id @slide_id
    update_ok(@slide && @lesson && @lesson.id == @slide.lesson_id)
  end
  
  def initialize_subjects
    @subjects = []
    UsersSubject.joins(:subject).where(:user_id => current_user.id).order('subjects.description ASC').each do |sbj|
      @subjects << sbj.subject
    end
    @subjects
  end
  
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
