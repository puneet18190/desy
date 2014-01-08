require 'pathname'

require 'mime/types'

require 'media'
require 'slide/math_images'

require 'export'
require 'export/lesson'
require 'export/lesson/scorm'
require 'export/lesson/scorm/renderer'
require 'export/lesson/shared'
require 'export/lesson/shared/scorm_and_scorm_renderer'

module Export
  module Lesson
    class Scorm
      class Renderer
        module Helper
          include Rails.application.routes.url_helpers
          
          SCORM_LOCALE         = I18n.default_locale
          SCORM_SCHOOL_LEVELS  = {}
          
          def scorm_locale
            SCORM_LOCALE
          end
          
          def scorm_school_level(school_level)
            resp = SCORM_SCHOOL_LEVELS[school_level]
            resp.nil? ? 'school' : resp.html_safe
          end
          
          def scorm_slide_title(slide)
            return 'Cover' if slide.cover?
            resp = "Slide #{slide.position - 1}"
            resp = "#{resp} - #{slide.title}" if slide.title.present?
            resp.html_safe
          end
          
        end
      end
    end
  end
end
