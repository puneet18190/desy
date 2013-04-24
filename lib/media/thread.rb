require 'media'
require 'enhanced_thread'

module Media

  # EnhancedThread version used for executing media processings
  class Thread < EnhancedThread

    # overwrites EnhancedThread.join in order to sett always +close_connection_before_execution+ to +true+
    def self.join(*procs)
      # maintains compatibility with super method arguments
      procs.pop if procs.last.is_a? Hash
      super(*procs, close_connection_before_execution: true)
    end

  end

end