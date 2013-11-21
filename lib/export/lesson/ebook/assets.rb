require 'fileutils'
require 'pathname'
require 'uri'

require 'sprockets'

require 'export'
require 'export/lesson'
require 'export/lesson/ebook'
require 'export/assets'

module Export
  module Lesson
    class Ebook
      class Assets < Assets

        FOLDER = ASSETS_FOLDER
        PATHS  = ASSETS_PATHS

        def paths
          @paths ||= ASSETS_PATHS
        end
        
      end
    end
  end
end
