class LessonEditorController < ApplicationController
  
  before_filter :initialize_lesson_with_owner
  layout 'lesson_editor'
  
  def index
    @lesson = Lesson.find params[:lesson_id]
    @slides = @lesson.slides.order :position
  end
  
  def new
    @subjects = [] 
    @current_user.users_subjects.each do |sbj|
      @subjects << sbj.subject
    end
  end
  
  def create
    # TODO controllare redirect
    new_lesson = @current_user.create_lesson params[:title], params[:description], params[:subject]
    Tag.create_tag_set 'Lesson', new_lesson.id, get_tags
    redirect_to "/lesson_editor/#{new_lesson.id}/index"
  end
  
  def update
    lesson = Lesson.find params[:lesson_id]
    lesson.title = params[:lesson][:title]
    lesson.description =  params[:lesson][:description]
    lesson.subject_id = params[:lesson][:subject_id]
    Tag.create_tag_set 'Lesson', lesson.id, get_tags
    lesson.save
    redirect_to lesson_editor_path(lesson.id)
  end
  
  def edit
    @subjects = []
    @lesson = Lesson.find params[:lesson_id]
    @current_user.users_subjects.each do |sbj|
      @subjects << sbj.subject
    end
  end
  
  ## prompt new slide choice ##
  def add_new_slide
    @slide = Slide.find params[:slide]
    respond_to do |format|
      format.js
    end
  end
  
  ## prompt image gallery in slide ##
  def show_gallery
    @media_elements = Image.limit(35)
    @slide = Slide.find params[:slide]
    respond_to do |format|
      format.js
    end
  end
  
  def add_slide
    save_current_slide
    @lesson = Lesson.find params[:lesson_id]
    @slide = @lesson.add_slide params[:kind], params[:position]
  end
  
  def save_slide
    save_current_slide
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def save_current_slide
    current_slide = Slide.find params[:slide_id]
    current_slide.title = params[:title] if params[:title]
    current_slide.text = params[:text] if params[:text]      
    current_slide.save
    (1...5).each do |i|
      if !params["media_element_#{i}"].blank?
        mes = MediaElementsSlide.where(:position => i, :slide_id => current_slide.id).first
        if mes.nil? || mes.media_element_id != params["media_element_#{i}"].to_i
          mes.destroy if !mes.nil?
          mes2 = MediaElementsSlide.new
          mes2.position = i
          mes2.slide_id = current_slide.id
          mes2.media_element_id = params["media_element_#{i}"].to_i
          mes2.alignment = params[:alignment] ? params[:alignment] : 0
          mes2.save!
        end
      end
    end
  end
  
  def get_tags
    tags = []
    if params[:tags]
      params[:tags].split(',').each do |tag|
        existing_tag = Tag.find_by_word tag
        if existing_tag.nil?
          tags << tag
        else
          tags << existing_tag.id
        end
      end
    else
      params[:lesson][:tags].split(',').each do |tag|
        existing_tag = Tag.find_by_word tag
        if existing_tag.nil?
          tags << tag
        else
          tags << existing_tag.id
        end
      end
    end
    tags
  end
  
end
