require 'media'
require 'media/audio'
require 'media/audio/editing'
require 'media/audio/editing/cmd'
require 'media/error'

module Media
  module Audio
    module Editing
      class Cmd
        class Conversion < Avconv
  
          self.formats        = FORMATS
          self.codecs         = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.audio.formats.send(f).codecs] } ]
          self.output_qa      = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.audio.formats.send(f).qa] } ] 
          self.output_threads = Hash[ FORMATS.map{ |f| [f, CONFIG.avtools.avconv.audio.formats.send(f).threads] } ]

  
          def initialize(input_file, output_file, format, input_file_info = nil)
            super([input_file], output_file, format)
  
            @input_file_info = input_file_info || Info.new(input_file)
            if astreams.blank?
              raise Error.new( 'at least one audio stream must be present', 
                               input_file: input_file, output_file: output_file, format: format, input_file_info: input_file_info )
            end
            
            output_options [ acodec, amap, achannels, ar ]
          end
  
          private
        
          def astreams
            @input_file_info.audio_streams
          end
  
          def amap
            '-map 0:a:0'
          end

          def achannels
            '-ac 2'
          end
          
        end
      end
    end
  end
end
