class Admin::ElementsController < ApplicationController
  before_filter :find_element, :only => [:destroy]
  layout 'admin'
  def index
    #@elements = Element.order('id DESC').page params[:page] #to manage others search
    #@elements = Element.joins(:user,:subject,:likes).select('elements.*, users.name, subjects.description, count(likes) AS likes_count').group('elements.id').sorted(params[:sort], "elements.id DESC").page(params[:page])
    @total_elements = MediaElement.joins(:user).sorted(params[:sort], "media_elements.id DESC")
    @elements = @total_elements.page(params[:page])
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @elements }
    end
  end
  
  def new
    @element = MediaElement.new
  end

  def destroy
    @element.destroy

    respond_to do |wants|
      wants.html { redirect_to(elements_url) }
      wants.xml  { head :ok }
    end
  end

  private
    def find_element
      @element = Element.find(params[:id])
    end

end
