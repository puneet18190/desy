module ApplicationHelper

  def controller_html_class
    "#{h controller_path}-controller"
  end

  def action_html_class
    "#{h action_name}-action"
  end

end
