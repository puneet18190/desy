module MediaEditing
  module Video
    module Logging

      STDOUT_LOG = 'stdout.log'
      STDERR_LOG = 'stderr.log'

      module ClassMethods
        def log_folder(folder_name = nil)
          folder_name ||= to_s.demodulize.underscore
          File.join Rails.root, VideoUploader.env_relative_path("log/video_editing/#{folder_name}")
        end      
      end
      
      module InstanceMethods

        def create_log_folder(folder_name = nil)
          @log_folder = nil
          @log_folder = log_folder(folder_name)
          FileUtils.mkdir_p @log_folder unless Dir.exists? @log_folder
          @log_folder
        end

        def log_folder(folder_name = nil)
          @log_folder || (
            folder_name ||= "#{Time.now.utc.strftime("%Y%m%d%H%M%S_%N")}_#{Thread.current.object_id}"
            File.join self.class.log_folder, folder_name
          )
        end
        
        def stdout_log(prefix = nil)
          File.join log_folder, (prefix ? "#{prefix}.#{STDOUT_LOG}" : STDOUT_LOG)
        end

        def stderr_log(prefix = nil)
          File.join log_folder, (prefix ? "#{prefix}.#{STDERR_LOG}" : STDERR_LOG)
        end

        def logs(prefix = nil)
          [%W(#{stdout_log(prefix)} a), %W(#{stderr_log(prefix)} a)]
        end
      end
      
      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end

    end
  end
end
