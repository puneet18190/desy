class EnhancedThread < Thread

  DATABASE_POOL = Rails.configuration.database_configuration[Rails.env]['pool']

  def self.join(*procs)
    procs.each_slice(DATABASE_POOL-1) { |slice| slice.map { |s| new &s }.each(&:join) }
    nil
  end

  def initialize(close_connection = true, &block)
    super(
      if close_connection
        proc {
          begin
            ActiveRecord::Base.connection.close
          rescue ActiveRecord::ConnectionTimeoutError
          end
          block.call
        }
      else
        block
      end
    )

    self.abort_on_exception = true
  end
end