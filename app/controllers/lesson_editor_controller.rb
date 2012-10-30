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
    # TODO sostituire parametri
    new_lesson = @current_user.create_lesson title, description, subject_id
    tags = []
    params[:tags].split(',').each do |tag|
      old_tag = Tag.find_by_word tag
      if existing_tag.nil?
        tags << tag
      else
        tags << existing_tag.id
      end
    end
    Tag.create_tag_set 'Lesson', new_lesson.id, tags
  end
  
end
