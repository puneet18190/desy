require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/audio/editing/composer'

module Media
  module Audio
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
