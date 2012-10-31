class LessonEditorController < ApplicationController
  
  before_filter :initialize_lesson_with_owner # initialize notifications??
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
    tags = []
    params[:tags].split(',').each do |tag|
      existing_tag = Tag.find_by_word tag
      if existing_tag.nil?
        tags << tag
      else
        tags << existing_tag.id
      end
    end
    Tag.create_tag_set 'Lesson', new_lesson.id, tags
    
    redirect_to "/lesson_editor/#{new_lesson.id}/index"
  end
  
end
