class ControllerInfo
  attr_reader :controller_name, :action_name

  def initialize(controller_name, action_name)
    @controller_name, @action_name = controller_name, action_name
  end
end