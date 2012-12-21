require 'media_editing'
require 'media_editing/video'
require 'media_editing/video/cmd'
require 'shellwords'
require 'subexec'

module MediaEditing
  module Video
    class Cmd
      class Avconv < MediaEditing::Video::Cmd
        attr_reader :subexec

        STREAM_TYPES_OPTIONS = { audio: 'a', video: 'v' }
        SH_VARS              = Hash[ MediaEditing::Video::CONFIG.avtools.avconv.cmd.sh_vars.marshal_dump.map{ |k, v| [k.to_s, v] } ]
        BIN                  = MediaEditing::Video::CONFIG.avtools.avconv.cmd.bin

        @subexec_options = { sh_vars: SH_VARS, timeout: MediaEditing::Video::AVCONV_SUBEXEC_TIMEOUT }

        def self.bin
          @bin ||= BIN
        end

        def initialize(input_files, output_file, format = nil)
          if format and not MediaEditing::Video::FORMATS.include? format
            raise MediaEditing::Video::Error.new( 'format unsupported',
                                           input_files: input_files, output_file: output_file, format: format )
          end

          @input_files, @output_file, @format = input_files, output_file, format
        end

        private
        def cmd!
          %Q[ #{self.class.bin}
                #{global_options.join(' ')}
                #{input_options_and_input_files}
                #{output_options.join(' ')}
                #{@output_file.shellescape} ].squish
        end

        def input_options_and_input_files
          @input_files.map{ |input| "#{input_options.join(' ')} -i #{input.shellescape}" }.join(' ')
        end

        def global_options(additional_options = [])
          @global_options ||= %W( -v 9 -loglevel 99 -benchmark -y -timelimit #{MediaEditing::Video::AVCONV_TIMEOUT.to_s.shellescape} )
          @global_options.concat additional_options
        end

        def input_options(additional_options = [])
          @input_options ||= []
          @input_options.concat additional_options
        end

        def output_options(additional_options = [])
          @output_options ||= default_output_options
          @output_options.concat additional_options
        end

        def default_output_options
          [ sn, output_threads, qv, qa, vbitrate ]
        end

        def sn
          '-sn'
        end

        # def reset_output_options
        #   @output_options = default_output_options
        # end

        def qv
          '-q:v 1'
        end

        def qa
          "-q:a #{MediaEditing::Video::AVCONV_OUTPUT_QA[@format].to_s.shellescape}" if @format
        end

        def codecs
          MediaEditing::Video::AVCONV_CODECS[@format] if @format
        end

        def vcodec
          "-c:v #{codecs[0].shellescape}"
        end

        def acodec
          "-c:a #{codecs[1].shellescape}"
        end

        def output_threads
          "-threads #{MediaEditing::Video::AVCONV_OUTPUT_THREADS[@format].to_s.shellescape}" if @format
        end

        def vbitrate
          '-b:v 2M' if @format == :webm
        end

      end
    end
  end
end