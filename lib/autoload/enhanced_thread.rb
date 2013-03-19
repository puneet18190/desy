class EnhancedThread < Thread

  DATABASE_POOL = Rails.configuration.database_configuration[Rails.env]['pool']
  MIN_THREADS   = 1
  MAX_THREADS   = Facter.fact(:processorcount).value.to_i * 2

  def self.join(*thread_blocks, close_connection_before_execution: false)
    n = DATABASE_POOL-Thread.list.count

    if n > MAX_THREADS
      n = MAX_THREADS 
    elsif n < MIN_THREADS
      n = MIN_THREADS
    end

    if n == 1
      thread_blocks.shift.try(:call)
      return thread_blocks.present? ? EnhancedThread.join(*thread_blocks, close_connection_before_execution: close_connection_before_execution) : nil
    end

    thread_blocks.each_slice(n).each_with_index { |slice, i|
      slice.map { |s| new(close_connection_before_execution, &s) }.each(&:join) 
    }
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