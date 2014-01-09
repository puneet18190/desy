require 'export'
require 'export/lesson'
require 'export/lesson/scorm'
require 'export/lesson/scorm/view'
require 'export/lesson/shared'
require 'export/lesson/shared/scorm_and_scorm_view'

module Export
  module Lesson
    class Scorm
      class View
        module Helper
          include Rails.application.routes.url_helpers
          
          SCORM_LOCALE         = I18n.default_locale
          SCORM_SCHOOL_LEVELS  = {}
          
          require 'export/lesson/shared/scorm_and_scorm_view'
          include Shared::ScormAndScormView
          
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
