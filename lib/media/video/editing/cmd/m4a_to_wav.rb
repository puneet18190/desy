require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/video/editing/cmd'
require 'shellwords'

module Media
  module Video
    module Editing
      class Cmd
        class M4aToWav < Avconv

          self.output_qa      = nil
  
          def initialize(input_file, output_file)
            super([input_file], output_file, nil)

            output_options [ acodec, amap ]
          end

          def sn
            nil
          end

          def qv
            nil
          end

          def amap
            '-map 0:a:0'
          end

          def acodec
            '-c:a pcm_s16le'
          end

          def output_threads
            '-threads auto'
          end
  
        end
      end
    end
  end
end
