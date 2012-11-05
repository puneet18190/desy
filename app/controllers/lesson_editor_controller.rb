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
    Tag.create_tag_set 'Lesson', lesson.id, get_tags
    lesson.save
  end
  
  def edit
    @lesson = Lesson.find params[:lesson_id]
  end
  
  def add_slide
    save_current_slide
    @lesson = Lesson.find params[:lesson_id]
    @slide = @lesson.add_slide params[:kind], params[:position]
  end
  
  private
  
  def save_current_slide
    current_slide = Slide.find params[:slide_id]
    current_slide.save
    (1...5).each do |i|
      if !params["media_element_#{i}"].blank?
        mes = MediaElementSlide.where(:position => i, :slide_id => current_slide.id).first
        if mes.nil? || mes.media_element_id != params["media_element_#{i}"].to_i
          mes.destroy
          mes2 = MediaElementSlide.new
          mes2.position = i
          mes2.slide_id = current_slide.id
          mes2.media_element_id = params["media_element_#{i}"].to_i
          mes2.save
        end
      end
    end
  end
  
  def get_tags
    tags = []
    params[:tags].split(',').each do |tag|
      existing_tag = Tag.find_by_word tag
      if existing_tag.nil?
        tags << tag
      else
        tags << existing_tag.id
      end
    end
    tags
  end
  
end
