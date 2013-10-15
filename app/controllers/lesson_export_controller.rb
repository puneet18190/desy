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
  
  before_filter :initialize_lesson_with_owner_or_public, :redirect_or_setup
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
    @slides = @lesson.slides
    @cover_img = @slides.first.media_elements_slides.first
    @with_exit = false
    @export = true
    redirect_to Export::Lesson::Archive.new(@lesson, render_to_string).url
  end

  def ebook
    redirect_to Export::Lesson::Ebook.new(@lesson).url
  end

  private
  
  def redirect_or_setup
    if !@ok
      redirect_to dashboard_path
      return
    end
  end
  
end
