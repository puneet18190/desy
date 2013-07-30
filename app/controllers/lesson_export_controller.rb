require 'export'

class LessonExportController < ApplicationController
  
  layout 'lesson_export', only: :export

  def export
    initialize_lesson

    @slides = @lesson.slides.order(:position)
    @cover_img = @slides.first.media_elements_slides.first

    # Meglio se creo lo zip e redirect
    # send_data Lesson::Download.new(@lesson, render_to_string(action: :index)).archive, type: 'application/zip', filename: 'test.zip'

    # send_data render_to_string(action: :index), type: 'text/html; charset=utf-8', filename: 'test.html'
    # render(action: :index)

    # export = Export::Lesson.new lesson, render_to_string(action: :index)
    # export.find_or_create_archive

    # redirect_to export.path

    archive_path = Export::Lesson::Archive.new(@lesson, render_to_string(action: :index)).public_path

    redirect_to archive_path
  end

end
