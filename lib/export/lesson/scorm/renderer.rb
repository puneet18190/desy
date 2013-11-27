require 'export'
require 'export/lesson'
require 'export/lesson/scorm'

module Export
  module Lesson
    class Scorm
      class Renderer < Renderer

        require 'export/lesson/shared/scorm_and_scorm_renderer'
        include Shared::ScormAndScormRenderer

        require 'export/lesson/scorm/renderer/helper'
        include Helper

      end
    end
  end
end
