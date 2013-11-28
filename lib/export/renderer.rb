require 'action_view/renderer/renderer'

require 'export'

module Export
  class Renderer < ActionView::Renderer

    # def render_with_default_context(options)
    #   render self.class::CONTEXT, options
    # end

    def view_renderer
      self.class::VIEW_RENDERER
    end

    def logger
      nil
    end

  end
end