require 'media_editing'
require 'media_editing/video'
require 'media_editing/logging'
require 'media_editing/in_tmp_dir'
require 'media_editing/video/cmd/video_stream_to_file'
require 'media_editing/video/cmd/replace_audio'

module MediaEditing
  module Video
    class ReplaceAudio
      
      include Logging
      include MediaEditing::InTmpDir

      CORRESPONDING_AUDIO_FORMATS = { mp4: :mp3, webm: :ogg }

      def initialize(video_inputs, audio_inputs, output_without_extension)
        unless video_inputs.is_a?(Hash)                       and 
               video_inputs.keys.sort == FORMATS.sort         and
               video_inputs.values.all?{ |v| v.is_a? String }
          raise Error.new("video_inputs must be an Hash with #{FORMATS.inspect} as keys and strings as values", video_inputs: video_inputs)
        end

        unless audio_inputs.is_a?(Hash)                                          and
               audio_inputs.keys.sort == CORRESPONDING_AUDIO_FORMATS.values.sort and
               audio_inputs.values.all?{ |v| v.is_a? String }
          raise Error.new("audio_inputs must be an Hash with #{CORRESPONDING_AUDIO_FORMATS.values.inspect} as keys and strings as values", audio_inputs: audio_inputs)
        end

        unless output_without_extension.is_a?(String)
          raise Error.new('output_without_extension must be a string', output_without_extension: output_without_extension)
        end

        @video_inputs, @audio_inputs, @output_without_extension = video_inputs, audio_inputs, output_without_extension
      end

      def run
        create_log_folder

        in_tmp_dir do
          FORMATS.map do |format|
            Thread.new do
              replace_audio(format)
            end.tap{ |t| t.abort_on_exception = true }
          end.each(&:join)
        end

        outputs
      end

      private
      def replace_audio(format)
        video_input, audio_input = @video_inputs[format], @audio_inputs[ CORRESPONDING_AUDIO_FORMATS[format] ]
        Cmd::ReplaceAudio.new(video_input, audio_input, video_stream_duration(video_input), output(format), format).run! *logs("1_#{format}")
      end

      def video_stream_duration(video_input)
        video_input_info = Info.new video_input

        video_input_no_audio_duration =
          if video_input_info.audio_streams.blank?
            video_input_info.duration
          else
            video_input_no_audio = tmp_path "video_no_audio.#{File.extname video_input}"
            Cmd::VideoStreamToFile.new(video_input, video_input_no_audio).run! *logs('0_video_stream_to_file')
            Info.new(video_input_no_audio).duration
          end
      end

      def output(format)
        "#{@output_without_extension}.#{format}"
      end

      def outputs
        Hash[ FORMATS.map{ |format| [format, output(format)] } ]
      end

    end
  end
end