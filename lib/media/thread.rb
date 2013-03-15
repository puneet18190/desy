require 'media'
require 'enhanced_thread'

module Media
  class Thread < EnhancedThread
    def self.join(*procs)
      super(true, *procs)
    end
  end
end