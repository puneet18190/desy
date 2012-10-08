# Controller per facilitare l'implementazione dei layouts
class ViewsController < ApplicationController
  
  layout false

  # Mostra la vista passatagli come parametro nell'url
  def show
    raise NotImplementedError, 'dovrebbe lanciare una 404' unless Rails.env.development?

    layout_name     = params[:layout_id].to_s
    controller_name = params[:controller_id].to_s
    action_name     = params[:action_id].try(:to_s) || 'index'

    layout_name = false if layout_name == 'false'

    render "#{controller_name}/#{action_name}", layout: layout_name
  end
  
end