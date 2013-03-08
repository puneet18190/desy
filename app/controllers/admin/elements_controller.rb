class Admin::ElementsController < AdminController
  
  before_filter :find_element, :only => [:destroy, :update, :load_element]
  layout 'admin'
  
  def index
    elements = params[:search] ? AdminSearchForm.search(params[:search], 'elements') : MediaElement.where(converted: true).order('id DESC')
    @elements = elements.page(params[:page])
    @location_root = Location.roots
    respond_to do |wants|
      wants.html
      wants.xml {render :xml => @elements}
    end
  end
  
  def new
    @files = current_user.admin_quick_uploading_cache
  end
  
  def edit
    @private_elements = MediaElement.where(user_id: current_user.id, is_public: false)
  end
  
  def quick_upload
    current_user.save_in_admin_quick_uploading_cache params[:media], params[:title], params[:description], params[:tags]
  end
  
  def create
    @new_media_element = MediaElement.new :media => params[:media]
    @new_media_element.title = params[:title].blank? ? 'title' : params[:title]
    @new_media_element.description = params[:description].blank? ? 'description' : params[:description]
    @new_media_element.tags = params[:tags].split(',').count < 4 ? 'tag1,tag2,tag3,tag4' : params[:tags]
    @new_media_element.user_id = current_user.id
    if !@new_media_element.save
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
    @element.destroyable_even_if_public = true
    if !@element.destroy
      @errors = @element.get_base_error
    end
  end
  
  def load_element
  end
  
  private
  
  def find_element
    @element = MediaElement.find(params[:id])
  end
  
end
