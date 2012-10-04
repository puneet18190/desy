# Controller per facilitare l'implementazione dei layouts
class LayoutsController < ApplicationController
  
  layout false

  # Mostra il layout passatogli come params[:id]
  def show
    raise NotImplementedError, 'dovrebbe lanciare una 404' unless Rails.env.development?

    layout_name = params[:id].to_s

    begin
      render layout_name
    rescue ActionView::MissingTemplate
      render text: "Layout '#{layout_name}' non trovato"
    end
  end
  
end