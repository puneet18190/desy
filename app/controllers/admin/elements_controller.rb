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
  
  def create
    @new_media_element = MediaElement.new :media => params[:media]
    @new_media_element.title = params[:title].blank? ? 'title' : params[:title]
    @new_media_element.description = params[:description].blank? ? 'description' : params[:description]
    @new_media_element.tags = params[:tags].split(',').count < 4 ? 'tag1,tag2,tag3,tag4' : params[:tags]
    @new_media_element.user_id = current_user.id
    if !@new_media_element.save!
      @errors = convert_media_element_uploader_messages @new_media_element.errors.messages
      fields = @new_media_element.errors.messages.keys
      if fields.include? :sti_type
        fields << :media if !fields.include? :media
        fields.delete :sti_type
      end
      @error_fields = []
      fields.each do |f|
        @error_fields << f.to_s
      end
    end
    
    render :js => @new_media_element
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
