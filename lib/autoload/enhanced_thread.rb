require 'facter'

# Child of Thread class which raises an exception if an error occurs and releases the database connection at the begin or at the end of the execution
class EnhancedThread < Thread

  # Number of the maximum database pools (taken from the database configuration)
  DATABASE_POOL = Rails.configuration.database_configuration[Rails.env]['pool']
  # Minimum amount of execution threads
  MIN_THREADS   = 1
  # Maximum amount of execution threads (corresponding to the number of processors * 2)
  MAX_THREADS   = Facter.fact(:processorcount).value.to_i * 2
  # proc used in order to close the database connection
  CLOSE_CONNECTION_PROC = proc {
    begin
      ActiveRecord::Base.connection.close
    rescue ActiveRecord::ConnectionTimeoutError
    end
  }

  # === Description
  #
  # Executes each of the passed +proc+ arguments in an EnhancedThread instance, caring the amount of threads executed in parallel to not exceed the amount of the database pools (which would cause an error)
  #
  # === Args
  #
  # * <b>*thread_blocks</b>: the procs which will be executed
  # * *close_connection_before_execution:* see EnhancedThread.new
  #
  # === Example
  #
  #   EnhancedThread.join(proc{ puts 'thread 1' }, proc{ puts 'thread 2' }, proc{ puts 'thread 3' }, close_connection_before_execution: true)
  def self.join(*thread_blocks, close_connection_before_execution: false)
    n = DATABASE_POOL-Thread.list.count

    if n > MAX_THREADS
      n = MAX_THREADS 
    elsif n < MIN_THREADS
      n = MIN_THREADS
    end

    if n == 1
      thread_blocks.shift.try(:call)
      return thread_blocks.present? ? join(*thread_blocks, close_connection_before_execution: close_connection_before_execution) : nil
    end

    thread_blocks.each_slice(n) { |slice| slice.map { |s| new(close_connection_before_execution, &s) }.each(&:join) }
    nil
  end

  # === Description
  # 
  # Creates a new EnhancedThread instance
  #
  # === Args
  #
  # * *close_connection_before_execution*: if +false+ closes the database connection before the thread execution, otherwise after; defaults to +false+
  #
  # === Example
  #
  #   EnhancedThread.new        { User.first } # works, since the database connection gets closed after of the execution
  #   EnhancedThread.new(false) { User.first } # same as above
  #   EnhancedThread.new(true)  { User.first } # raises an error
  def initialize(close_connection_before_execution = false, &block)
    thread_block = 
      if close_connection_before_execution
        proc {
          CLOSE_CONNECTION_PROC.call
          block.call
        }
      else
        proc {
          begin
            block.call
          ensure
            CLOSE_CONNECTION_PROC.call
          end
        }
      end

    super(&thread_block)

    self.abort_on_exception = true
  end

end