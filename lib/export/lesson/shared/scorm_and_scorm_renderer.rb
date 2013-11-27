require 'action_view/lookup_context'

require 'export'
require 'export/lesson'
require 'export/lesson/shared'

module Export
  module Lesson
    module Shared
      module ScormAndScormRenderer
        require 'export/lesson/scorm/renderer'

        TEMPLATES_FOLDER = Lesson::FOLDER.join 'scorms', 'templates'
        LOOKUP_CONTEXT   = ActionView::LookupContext.new TEMPLATES_FOLDER
        VIEW_RENDERER    = Scorm::Renderer.new LOOKUP_CONTEXT
        CONTEXT          = VIEW_RENDERER

      end
    end
  end
end
