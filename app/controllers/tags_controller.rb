class TagsController < ApplicationController
  def get_list
    if params[:term]
      @tags = Tag.where("word ILIKE '#{params[:term]}%'").select("id, word AS value").limit(20)
    else
      @tags = Tag.select("id, word AS value").limit(20)
    end
    
    if @tags.count == 0
      @tags = [:id=>0,:value=>params[:term]]
    end
    render :json => @tags
  end
end