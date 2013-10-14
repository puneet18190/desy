require 'action_view/renderer/renderer'

require 'export'
require 'export/lesson'
require 'export/lesson/ebook'

module Export
  module Lesson
    class Ebook
      class Renderer < ActionView::Renderer

        require 'export/lesson/shared/ebook_and_ebook_renderer'
        include Shared::EbookAndEbookRenderer

        require 'export/lesson/ebook/renderer/helper'
        include Helper

        def render_with_default_context(options)
          render CONTEXT, options
        end

      end
    end
  end
end