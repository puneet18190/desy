require 'facter' unless WINDOWS

module Media
  class Queue
    PROCESSORS_COUNT =
      begin
        Facter.fact(:processorcount).value.to_i
      rescue
        1
      end 

    # Number of the maximum database pools (taken from the database configuration)
    DATABASE_POOL = Rails.configuration.database_configuration[Rails.env]['pool']

    # Minimum threads amount (0: no new threads, execution inside Thread.current)
    MIN_THREADS = 0
    
    # Maximum amount of execution threads
    MAX_THREADS = [PROCESSORS_COUNT-1, DATABASE_POOL-1].min

    CLOSE_CONNECTION_PROC = proc {
      # begin
        ActiveRecord::Base.connection.close
      # rescue ActiveRecord::ConnectionTimeoutError
      # end
    }

    def self.join(*procs, close_connection_before_execution: false)
      new(*procs, close_connection_before_execution: close_connection_before_execution).run
    end


    def initialize(*procs, close_connection_before_execution: false)
      @procs = procs.map do |proc|
        if close_connection_before_execution
          Proc.new {
            CLOSE_CONNECTION_PROC.call
            proc.call
          }
        else
          Proc.new {
            begin
              proc.call
            ensure
              CLOSE_CONNECTION_PROC.call
            end
          }
        end
      end
    end

    def run
      @procs.threach(parallel_jobs) { |proc| proc.call }
    end

    private

    def current_threads_amount
      Thread.list.size
    end

    def parallel_jobs
      [MAX_THREADS-current_threads_amount, MIN_THREADS].max
    end

  end
end
