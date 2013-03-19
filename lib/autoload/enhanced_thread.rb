class EnhancedThread < Thread

  DATABASE_POOL = Rails.configuration.database_configuration[Rails.env]['pool']
  MAX_THREADS   = 8
  MIN_THREADS   = 1

  def self.join(*procs, close_connection_before_execution: false)
    n = DATABASE_POOL-1

    if n > MAX_THREADS
      n = MAX_THREADS 
    elsif n < MIN_THREADS
      n = MIN_THREADS
    end
    
    procs.each_slice(n) { |slice| slice.map { |s| new(close_connection_before_execution, &s) }.each(&:join) }
    nil
  end

  def initialize(close_connection_before_execution = false, &block)
    thread_block = 
      if close_connection_before_execution
        proc {
          begin
            ActiveRecord::Base.connection.close
          rescue ActiveRecord::ConnectionTimeoutError
          end
          block.call
        }
      else
        proc {
          begin
            block.call
          ensure
            begin
              ActiveRecord::Base.connection.close
            rescue ActiveRecord::ConnectionTimeoutError
            end
          end
        }
      end

    super(&thread_block)

    self.abort_on_exception = true
  end
end