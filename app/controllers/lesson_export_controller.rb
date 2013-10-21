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
  
  skip_before_filter :authenticate
  before_filter :initialize_and_authenticate_for_lesson_export, :redirect_or_setup
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
  
  def initialize_and_authenticate_for_lesson_export
    if logged_in
      if current_user.trial?
        @ok = @lesson.is_public
        return
      else
        @ok = (@lesson.is_public || @lesson.user_id == current_user.id)
        return
      end
    end
    @ok = (@lesson.is_public || @lesson.token == params[:token])
  end
  
  def redirect_or_setup
    if !@ok
      redirect_to dashboard_path
      return
    end
    # TODO controllare che non ci siano video o audio in conversione, e se sì renderizzare la pagina apposita
  end
  
end
