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
  layout 'lesson_archive', :only => :archive
  
  def archive
    @slides = @lesson.slides.preload(:media_elements_slides, {:media_elements_slides => :media_element}, :documents_slides, {:documents_slides => :document}).order(:position)
    redirect_to Export::Lesson::Archive.new(@lesson, render_to_string).url
  end
  
  def ebook
    redirect_to Export::Lesson::Ebook.new(@lesson).url
  end
  
  def scorm
    #rendered_slides = Hash[ slides.map do |record|
    #  [ record.id, render_to_string template: 'lesson_export/scorm/slide.html', layout: 'lesson_scorm/slide' ]
    #end ]
    #Export::Lesson::Scorm.new(@lesson, rendered_slides).url
  end
  
  private
  
  def redirect_or_setup
    if !@ok
      redirect_to dashboard_path
      return
    end
    # TODO controllare che non ci siano video o audio in conversione, e se sì renderizzare la pagina apposita
  end
  
end
