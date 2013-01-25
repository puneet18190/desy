class TagsController < ApplicationController
  
  def get_list
    @tags = Tag.get_tags_for_autocomplete(params[:term]
    render :json => @tags
  end
  
end
