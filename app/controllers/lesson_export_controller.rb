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
    rendered_slides = {}
    @lesson.slides.each do |slide|
      @slide_id = slide.id
      rendered_slides[slide.id] = render_to_string({
        :template => "lesson_viewer/slides/_#{slide.kind}",
        :layout   => 'lesson_scorm',
        :locals   => {
          :slide    => slide,
          :url_type => UrlTypes::SCORM,
          :loaded   => true
        }
      })
    end
    redirect_to Export::Lesson::Scorm.new(@lesson, rendered_slides).url
  end
  
  private
  
  def initialize_and_authenticate_for_lesson_export
    @lesson_id = correct_integer?(params[:lesson_id]) ? params[:lesson_id].to_i : 0
    @lesson = Lesson.find_by_id @lesson_id
    @ok = !@lesson.nil?
    return if !@ok
    if logged_in?
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
