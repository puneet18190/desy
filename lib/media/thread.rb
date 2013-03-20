require 'media'
require 'enhanced_thread'

module Media
  class Thread < EnhancedThread
    def self.join(*procs)
      # maintains compatibility with super method arguments
      procs.pop if procs.last.is_a? Hash
      super(*procs, close_connection_before_execution: true)
    end
  end
end