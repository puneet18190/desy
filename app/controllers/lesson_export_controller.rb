require 'export'

# == Description
#
# Controller for exporting lessons
#
# == Models used
#
# * Lesson
# * Slide
# * DocumentsSlide
# * MediaElementsSlide
#
class LessonExportController < ApplicationController
  
  before_filter :initialize_lesson_with_owner_or_public
  layout 'lesson_export', only: :export
  
  # === Description
  #
  # Downloads the lesson offline.
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_lesson_with_owner_or_public
  #
  def export
    @slides = @lesson.slides.order(:position)
    @cover_img = @slides.first.media_elements_slides.first
    archive_path = Export::Lesson::Archive.new(@lesson, render_to_string(action: :index)).public_path
    redirect_to archive_path
  end
  
end
