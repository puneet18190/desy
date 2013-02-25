class Admin::ElementsController < AdminController
  before_filter :find_element, :only => [:destroy, :update]
  layout 'admin'
  def index
    #@elements = Element.order('id DESC').page params[:page] #to manage others search
    #@elements = Element.joins(:user,:subject,:likes).select('elements.*, users.name, subjects.description, count(likes) AS likes_count').group('elements.id').sorted(params[:sort], "elements.id DESC").page(params[:page])
    if params[:search]
      elements = AdminSearchForm.search(params[:search],'elements')
    else
      elements = MediaElement.order('id DESC')
    end
    
    @elements = elements.page(params[:page])
    @location_root = Location.roots
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @elements }
    end
  end
  
  def new
    @element = MediaElement.new
  end
  
  def edit
    @private_elements = MediaElement.where(user_id: current_user.id, is_public: false);
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
    if params[:commit]
      render :new
    end
  end
  
  
  def update
    @element.title = params[:title] if params[:title]
    @element.description = params[:description] if params[:description]
    @element.tags = params[:tags] if params[:tags]
    if params[:is_public]
      @element.is_public = true
      @element.publication_date = Time.zone.now
    end
    
    if !@element.save
      @errors = convert_item_error_messages @element.errors.messages
      @error_fields = @element.errors.messages.keys
      render :nothing => true
    else
      render :nothing => true
    end
  end
  
  def destroy
    if !@element.check_and_destroy
      @error = @element.get_base_error
    end
    render :nothing => true
  end

  private
    def find_element
      @element = MediaElement.find(params[:id])
    end

end
