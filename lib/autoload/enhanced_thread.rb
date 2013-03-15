class EnhancedThread < Thread

  DATABASE_POOL = Rails.configuration.database_configuration[Rails.env]['pool']

  def self.join(close_connection_before_execution = false, *procs)
    procs.each_slice(DATABASE_POOL-1) { |slice| slice.map { |s| new(close_connection_before_execution, &s) }.each(&:join) }
    nil
  end

  def initialize(close_connection_before_execution = false, &block)
    super(
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
    )

    self.abort_on_exception = true
  end
end