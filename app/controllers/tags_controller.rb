class TagsController < ApplicationController
  
  def get_list
    @tags = []
    if params[:term]
      @tags = Tag.where("word ILIKE '#{params[:term]}%'").select("id, word AS value").limit(20).order(:word)
    end
    render :json => @tags
  end
  
end
