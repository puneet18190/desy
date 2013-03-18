require 'media'
require 'enhanced_thread'

module Media
  class Thread < EnhancedThread
    def self.join(*procs)
      super(*procs, close_connection_before_execution: true)
    end
  end
end