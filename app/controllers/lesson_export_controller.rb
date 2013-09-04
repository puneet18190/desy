require 'export'

class LessonExportController < ApplicationController
  
  layout 'lesson_export', only: :export
  
  def export
    initialize_lesson # TODO
    @slides = @lesson.slides.order(:position)
    @cover_img = @slides.first.media_elements_slides.first
    archive_path = Export::Lesson::Archive.new(@lesson, render_to_string(action: :index)).public_path
    redirect_to archive_path
  end
  
end
