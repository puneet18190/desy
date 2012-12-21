require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/video/editing/composer'

module Media
  module Video
    module Editing
      class Composer
        class Job < Struct.new(:params)
          def perform
            Composer.new(params).run
          end
        end
      end
    end
  end
end
