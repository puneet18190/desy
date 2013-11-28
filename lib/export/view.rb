require 'action_view/base'

require 'export'

module Export
  class View < ActionView::Base

    # def render_with_default_context(options)
    #   render self.class::CONTEXT, options
    # end

    # def view_renderer
    #   self.class::VIEW_RENDERER
    # end

    # def logger
    #   nil
    # end

  end
end