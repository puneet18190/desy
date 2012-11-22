class LessonEditorController < ApplicationController
  
  FOR_PAGE = {
    MediaElement::IMAGE_TYPE => CONFIG['images_for_page_in_gallery'],
    MediaElement::IMAGE_TYPE => CONFIG['audios_for_page_in_gallery'],
    MediaElement::IMAGE_TYPE => CONFIG['videos_for_page_in_gallery']
  }
  
  before_filter :initialize_lesson_with_owner, :only => [:index, :update, :edit]
  before_filter :initialize_subjects, :only => [:new, :edit]
  before_filter :initialize_lesson_with_owner_and_slide, :only => [:show_gallery]
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
      redirect_to "/lesson_editor/#{new_lesson.id}/index"
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
      @sti_types = {:video => MediaElement::VIDEO_TYPE.downcase, :image => MediaElement::IMAGE_TYPE.downcase, :audio => MediaElement::AUDIO_TYPE.downcase}
      @img_position = params[:position]
    end
  end
  
  def add_slide
    @current_slide = Slide.find(params[:current_slide])
    params[:slide_id] = params[:current_slide]
    save_current_slide
    @lesson = Lesson.find @current_slide.lesson.id
    @slide = @lesson.add_slide params[:kind], @current_slide.position + 1
    redirect_to lesson_editor_path(@lesson.id)
  end
  
  def save_slide
    save_current_slide
    respond_to do |format|
      format.js
    end
  end
  
  def delete_slide
    slide = Slide.find(params[:slide_id])
    if slide.destroy_with_positions
      redirect_to lesson_editor_path(slide.lesson.id)
    else
      redirect_to :back, notice: "#{t 'captions.slide_not_deleted'}"
    end
  end
  
  def change_slide_position
    slide = Slide.find(params[:slide_id])
    slide.change_position(params[:new_position].to_i)
    @lesson = Lesson.find slide.lesson.id
    @slides = @lesson.slides.order :position
    @slide = @slides.first
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def initialize_lesson_with_owner_and_slide
    initialize_lesson_with_owner
    @slide_id = correct_integer?(params[:slide_id]) ? params[:slide_id].to_i : 0
    @slide = Slide.find_by_id @slide_id
    update_ok(@slide && @lesson.id == @slide.lesson_id)
  end
  
  def initialize_subjects
    @subjects = []
    @current_user.users_subjects.each do |sbj|
      @subjects << sbj.subject
    end
  end
  
  def save_current_slide
    @slide.update_with_media_elements()
    # TODO aggiungere lesson.modify after save
    current_slide = Slide.find params[:slide_id]
    current_slide.title = params[:title] if params[:title]
    current_slide.text = params[:text] if params[:text]
    current_slide.save
    (1...5).each do |i|
      if !params["media_element_#{i}"].blank?
        mes = MediaElementsSlide.where(:position => i, :slide_id => current_slide.id).first
        if mes.nil? || mes.media_element_id != params["media_element_#{i}"].to_i || mes.alignment != params["media_element_align_#{i}"].to_i
          mes.destroy if !mes.nil? #update id, don't destroy
          mes2 = MediaElementsSlide.new
          mes2.position = i
          mes2.slide_id = current_slide.id
          mes2.media_element_id = params["media_element_#{i}"].to_i
          #TODO mettere default a zero per alignment 
          mes2.alignment = params["media_element_align_#{i}"]
          mes2.caption = params["caption_#{i}"] #TODO da controllare
          mes2.save!
        else
          mes.caption = params["caption_#{i}"] if params["caption_#{i}"]#TODO da controllare
          mes.save
        end
      end
    end
  end
  
end
