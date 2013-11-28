require 'export'
require 'export/lesson'
require 'export/lesson/ebook'

module Export
  module Lesson
    class Ebook
      class View < View

        require 'export/lesson/ebook/view/helper'

        include Helper
        
        self.prepare nil, Helper

      end
    end
  end
end