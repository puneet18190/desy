require 'media'

module Media
  class Thread < Thread
    def self.join(*procs)
      procs.each_slice(DATABASE_POOL-1) do |slice|
        slice.map do |s|
          # while ActiveRecord::Base.connection_pool.connections.select(&:in_use?).count >= DATABASE_POOL do
          #   _d 'sleeping', ActiveRecord::Base.connection_pool.connections.select(&:in_use?).count, DATABASE_POOL
          #   sleep 0.1
          # end
          # _d ActiveRecord::Base.connection_pool.connections.select(&:in_use?).count, DATABASE_POOL

          new {
            # _d ActiveRecord::Base.connection_pool.connections.select(&:in_use?).count
            begin
              ActiveRecord::Base.connection.close
            rescue ActiveRecord::ConnectionTimeoutError
            end
            # _d Thread.list.count
            s.call
            # _d ActiveRecord::Base.connection_pool.connections.select(&:in_use?).count
          }
        end.each(&:join)
      end
      nil
    end

    def initialize
      super
      self.abort_on_exception = true
    end
  end
end