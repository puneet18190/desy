class MediaElementsEditorController < ApplicationController
  
  layout 'media_elements_editor'
  
  def index
    
  end
  ## prompt image gallery in slide ##
  def show_gallery
    @media_elements = @current_user.own_media_elements(1, 35)[:records]
    respond_to do |format|
      format.js
    end
  end
  
end
