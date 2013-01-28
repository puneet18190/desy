class TagsController < ApplicationController
  
  def get_list
    @tags = Tag.get_tags_for_autocomplete(params[:term])
    render :json => @tags
  end
  
  def check_presence
    render :json => {:ok => Tag.where(:word => params[:word]).any?}
  end
  
end
