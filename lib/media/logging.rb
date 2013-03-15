require 'media'
require 'env_relative_path'

module Media
  module Logging

    STDOUT_LOG = 'stdout.log'
    STDERR_LOG = 'stderr.log'

    include EnvRelativePath

    def self.remove_folder!
      FileUtils.rm_rf env_relative_path Rails.root.join('log', to_s.split('::').take(1).join('::').underscore).to_s
    end

    module ClassMethods
      def log_folder(folder_name = nil)
        nesting = folder_name ? 3 : 4
        log_folder_const = self.to_s.split('::').take(nesting).join('::').underscore
        
        env_relative_path Rails.root, 'log', log_folder_const, folder_name.to_s
      end
    end
    
    module InstanceMethods
      def create_log_folder(folder_name = nil)
        self.thread_relative_log_folder = nil
        self.thread_relative_log_folder = log_folder(folder_name)
        FileUtils.mkdir_p thread_relative_log_folder
        thread_relative_log_folder
      end


      def log_folder(folder_name = nil)
        @log_folder || thread_relative_log_folder || (
          folder_name ||= "#{Time.now.utc.strftime("%Y-%m-%d_%H-%M-%S_%N")}_#{::Thread.current.object_id}"
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

      private
      def thread_relative_log_folder_name
        if Thread.current == Thread.main
          :@log_folder
        else
          :"@log_folder_for_thread_#{Thread.current.object_id}"
        end
      end

      def thread_relative_log_folder
        instance_variable_get thread_relative_log_folder_name
      end

      def thread_relative_log_folder=(thread_relative_log_folder)
        instance_variable_set thread_relative_log_folder_name, thread_relative_log_folder
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, EnvRelativePath
      receiver.send :include, InstanceMethods
    end

  end
end
