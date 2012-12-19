class SensitiveThread < Thread
  def initialize
    super
    self.abort_on_exception = true
  end
end