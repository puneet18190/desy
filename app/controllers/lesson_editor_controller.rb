class LessonEditorController < ApplicationController
  
  before_filter :initialize_lesson_with_owner
  layout 'lesson_editor'
  
  def index
    @lesson = Lesson.find params[:lesson_id]
    @slides = @lesson.slides.order :position
    @slide = @slides.first
    #TODO pass a parameter for the slide to redirect to after add_slide
    #@slide_to = params[:slide_position] if params[:slide_position]
  end
  
  def new
    @subjects = [] 
    @current_user.users_subjects.each do |sbj|
      @subjects << sbj.subject
    end
  end
  
  def create
    # TODO controllare redirect
    new_lesson = @current_user.create_lesson params[:title], params[:description], params[:subject], params[:tags]
    if new_lesson
      redirect_to "/lesson_editor/#{new_lesson.id}/index"
    else
      redirect_to :back, notice: "#{t 'captions.lesson_not_created'}"
    end
  end
  
  def update
    lesson = Lesson.find params[:lesson_id]
    lesson.title = params[:lesson][:title]
    lesson.description =  params[:lesson][:description]
    lesson.subject_id = params[:subject]
    lesson.tags = params[:lesson][:tags]
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
    if params[:kind_of]
      @kind_of = params[:kind_of]
    else
      @kind_of = "image"
    end
    @media_elements = @current_user.own_media_elements(1, 35, @kind_of)[:records]
    @slide = Slide.find params[:slide]
    @img_position = params[:position]
    respond_to do |format|
      format.js
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
  
  def save_current_slide
    #TODO aggiungere lesson.modify after save
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
          mes2.save!

        end
      end
    end
  end
  
end
