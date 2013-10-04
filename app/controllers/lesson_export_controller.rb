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
  layout 'lesson_archive', only: :archive
  
  # === Description
  #
  # Downloads the lesson as archive
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_lesson_with_owner_or_public
  #
  def archive
    if !@ok
      redirect_to '/dashboard'
    else
      @slides = @lesson.slides.order(:position)
      @cover_img = @slides.first.media_elements_slides.first
      @with_exit = false
      @export = true
      archive_url = Export::Lesson::Archive.new(@lesson, render_to_string).url
      redirect_to archive_url
    end
  end
  
end
