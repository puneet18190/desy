class LessonEditorController < ApplicationController
  
  FOR_PAGE = {
    MediaElement::IMAGE_TYPE => CONFIG['images_for_page_in_gallery'],
    MediaElement::AUDIO_TYPE => CONFIG['audios_for_page_in_gallery'],
    MediaElement::VIDEO_TYPE => CONFIG['videos_for_page_in_gallery']
  }
  
  before_filter :initialize_lesson_with_owner, :only => [:index, :update, :edit]
  before_filter :initialize_subjects, :only => [:new, :edit]
  before_filter :initialize_lesson_with_owner_and_slide, :only => [:add_slide, :show_gallery, :save_slide, :delete_slide, :change_slide_position]
  before_filter :initialize_kind, :only => :add_slide
  before_filter :initialize_position, :only => :change_slide_position
  layout 'lesson_editor'
  
  def index
    if !@ok
      redirect_to '/dashboard'
      return
    else
      @slides = @lesson.slides.order(:position)
      #TODO pass a parameter for the slide to redirect to after add_slide
      #@slide_to = params[:slide_position] if params[:slide_position]
    end
  end
  
  def new
  end
  
  def create
    # TODO controllare redirect
    new_lesson = @current_user.create_lesson params[:title], params[:description], params[:subject], params[:tags]
    if new_lesson
      redirect_to "/lessons/#{new_lesson.id}/slides/edit"
    else
      redirect_to :back, notice: t('captions.lesson_not_created')
    end
  end
  
  def update
    if !@ok
      redirect_to '/dashboard'
      return
    else
      @lesson.title = params[:lesson][:title]
      @lesson.description =  params[:lesson][:description]
      @lesson.subject_id = params[:subject]
      @lesson.tags = params[:lesson][:tags]
      @lesson.modified
      @lesson.save
      redirect_to lesson_editor_path(@lesson_id)
    end
  end
  
  def edit
    if !@ok
      redirect_to '/dashboard'
      return
    end
  end
  
  ## prompt image gallery in slide ##
  def show_gallery
    if @ok
      @media_element_type = @slide.accepted_media_element_sti_type
      @media_elements = @current_user.own_media_elements(1, FOR_PAGE[@media_element_type], @media_element_type.downcase)[:records]
      @media_element_type = @media_element_type.downcase
      @img_position = params[:position]
      @sme = get_media_element_at(@slide, @img_position)
    end
  end
  
  def add_slide
    if @ok
      @lesson.add_slide @kind, (@slide.position + 1)
      @slides = @lesson.slides.order(:position)
      @slide_to = @slide.position + 1
    end
  end
  
  def save_slide
    save_current_slide if @ok
  end
  
  def delete_slide
    if @ok
      @slide.destroy_with_positions
      @lesson = @slide.lesson
      @slides = @lesson.slides.order(:position)
      @slide_to = @slide.position - 2
    end
  end
  
  def change_slide_position
    if @ok
      @slide.change_position(@position)
      @slides = @lesson.slides.order(:position)
      @slide_to = @position - 1
    end
  end
  
  private
  
  def get_media_element_at(slide, position)
    accepted = slide.accepted_media_element_sti_type
    case accepted
      when MediaElement::IMAGE_TYPE
        slide.image_at position
      when MediaElement::AUDIO_TYPE
        slide.audio_at position
      when MediaElement::VIDEO_TYPE
        slide.video_at position
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
    UsersSubject.joins(:subject).where(:user_id => @current_user.id).order('subjects.description ASC').each do |sbj|
      @subjects << sbj.subject
    end
    @subjects
  end
  
  def save_current_slide
    media_elements_params = {}
    (1...5).each do |i|
      if !params["media_element_#{i}"].blank?
        media_element_id = correct_integer?(params["media_element_#{i}"]) ? params["media_element_#{i}"].to_i : 0
        alignment = params["media_element_align_#{i}"].to_i
        caption = params["caption_#{i}"]
        media_elements_params[i] = [media_element_id, alignment, caption]
      end
    end
    @slide.update_with_media_elements(params[:title], params[:text], media_elements_params)
  end
  
end
