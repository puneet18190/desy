require 'media'
require 'media/video'
require 'media/video/editing'
require 'media/logging'
require 'media/similar_durations'
require 'media/info'
require 'media/error'
require 'env_relative_path'
require 'media/video/editing/cmd/conversion'
require 'media/image/editing/resize_to_fill'

module Media
  module Video
    module Editing
      class Conversion
  
        include EnvRelativePath
        include Logging
        include SimilarDurations
  
        TEMP_FOLDER        = Rails.root.join(env_relative_path('tmp/media/video/editing/conversions')).to_s
        DURATION_THRESHOLD = CONFIG.duration_threshold
  
        def self.log_folder
          super 'conversions'
        end

        def self.temp_folder(model_id)
          File.join TEMP_FOLDER, model_id.to_s
        end

        def self.temp_path(model_id, original_filename)
          File.join temp_folder(model_id), original_filename
        end
  
        attr_reader :model_id, :uploaded_path
  
        # Example: new('/tmp/path.abcdef', '/path/to/desy/public/media_elements/13/valid-video', 'valid video.flv', 13)
        def initialize(uploaded_path, output_path_without_extension, original_filename, model_id)
          @model_id = model_id
          init_model
  
          @uploaded_path                 = uploaded_path
          @output_path_without_extension = output_path_without_extension
          @original_filename             = original_filename
        end
  
        def run
          begin
            FORMATS.map{ |format| SensitiveThread.new { convert_to(format) } }.each(&:join)
  
            mp4_file_info  = Info.new output_path(:mp4)
            webm_file_info = Info.new output_path(:webm)
  
            unless similar_durations?(mp4_file_info.duration, webm_file_info.duration) 
              raise Error.new( 'output videos have different duration', 
                               model_id: model_id, mp4_duration: mp4_file_info.duration, webm_duration: webm_file_info.duration )
            end
  
            cover_path = File.join output_folder, COVER_FORMAT % output_filename_without_extension
            extract_cover output_path(:mp4), cover_path, mp4_file_info.duration
  
            thumb_path = File.join output_folder, THUMB_FORMAT % output_filename_without_extension
            extract_thumb cover_path, thumb_path, *THUMB_SIZES
  
          rescue StandardError => e
            FileUtils.rm_rf output_folder if Dir.exists? output_folder
            
            input_path = 
              if File.exists? temp_path
                temp_path
              elsif File.exists? uploaded_path
                uploaded_path
              end
            FileUtils.cp input_path, create_log_folder if input_path

            if model.present? and model.user_id.present?
              Notification.send_to model.user_id, I18n.t("notifications.#{model.class.to_s.downcase}.upload.failed", item: model.title)
              model.destroyable_even_if_not_converted = true
              model.destroy
            end

            raise e
          end
  
          model.converted     = true
          model.rename_media  = true
          model.mp4_duration  = mp4_file_info.duration
          model.webm_duration = webm_file_info.duration
          model.media         = output_filename_without_extension
          model[:media]       = output_filename_without_extension
          model.save!

          FileUtils.rm temp_path

          Notification.send_to model.user_id, I18n.t("notifications.#{model.class.to_s.downcase}.upload.ok", item: model.title)
        end
  
        def extract_thumb(input, output, width, height)
          Image::Editing::ResizeToFill.new(input, output, width, height).run
        end
  
        def extract_cover(input, output, duration)
          seek = duration / 2
          Cmd::ExtractFrame.new(input, output, seek).run! %W(#{stdout_log} a), %W(#{stderr_log} a)
          unless File.exists? output
            raise Error.new( 'unable to create cover',
                             model_id: model_id, input: input, output: output, stdout_log: stdout_log, stderr_log: stderr_log)
          end
        end
  
        def convert_to(format)
          if not File.exists? uploaded_path and not File.exists? temp_path
            raise Error.new( "at least one between uploaded_path and temp_path must exist", 
                             temp_path: temp_path, uploaded_path: uploaded_path, format: format )
          end
  
          FileUtils.mkdir_p temp_folder unless Dir.exists? temp_folder
  
          # If temp_path already exists, I assume that someone has already processed it before;
          # so I use it (I use it as cache)
          FileUtils.mv uploaded_path, temp_path unless File.exists? temp_path
  
          FileUtils.mkdir_p output_folder unless Dir.exists? output_folder
          
          begin
            output_path = output_path(format)

            log_folder = create_log_folder
            stdout_log, stderr_log = stdout_log(format), stderr_log(format)
  
            Cmd::Conversion.new(temp_path, output_path, format).run! %W(#{stdout_log} a), %W(#{stderr_log} a)
          rescue StandardError => e
            FileUtils.rm_rf output_folder if Dir.exists? output_folder
            raise e
          end
  
        end

        private
        def output_path(format)
          "#{@output_path_without_extension}.#{format}"
        end
  
        def uploaded_path_extension
          File.extname @uploaded_path
        end
  
        def output_filename_without_extension
          File.basename @output_path_without_extension
        end
  
        def output_folder
          File.dirname @output_path_without_extension
        end
  
        def temp_path
          self.class.temp_path(model_id, @original_filename)
        end
  
        def temp_folder
          File.dirname temp_path
        end
  
        def log_folder(_ = nil)
          super model_id.to_s
        end
  
        def model
          @model ||= ::Video.find model_id
        end
        alias init_model model
  
      end
    end
  end
end
