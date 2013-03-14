require 'media'
require 'env_relative_path'

module Media
  module Logging

    STDOUT_LOG = 'stdout.log'
    STDERR_LOG = 'stderr.log'

    module ClassMethods
      def log_folder(folder_name = nil)
        nesting = folder_name ? 3 : 4
        log_folder_const = self.to_s.split('::').take(nesting).join('::').underscore
        
        env_relative_path Rails.root, 'log', log_folder_const, folder_name.to_s
      end
    end
    
    module InstanceMethods
      def create_log_folder(folder_name = nil)
        self.log_folder_instance_variable = nil
        self.log_folder_instance_variable = log_folder(folder_name)
        FileUtils.mkdir_p log_folder_instance_variable
        log_folder_instance_variable
      end


      def log_folder(folder_name = nil)
        log_folder_instance_variable || (
          folder_name ||= "#{Time.now.utc.strftime("%Y%m%d%H%M%S_%N")}_#{::Thread.current.object_id}"
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
      def log_folder_instance_variable_name
        :"@log_folder_for_thread_#{Thread.current.object_id}"
      end

      def log_folder_instance_variable
        instance_variable_get log_folder_instance_variable_name
      end

      def log_folder_instance_variable=(log_folder_instance_variable)
        instance_variable_set log_folder_instance_variable_name, log_folder_instance_variable
      end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, EnvRelativePath
      receiver.send :include, InstanceMethods
    end

  end
end
