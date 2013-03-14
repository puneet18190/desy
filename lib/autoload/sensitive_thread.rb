class SensitiveThread < Thread
  def initialize
    super
    self.abort_on_exception = true
    ActiveRecord::Base.connection.close
  end
end