class Admin::MediaElementsController < AdminController
  
  before_filter :find_element, :only => [:destroy, :update, :load_element]
  before_filter :initialize_media_element_with_owner_and_private, :only => :update
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
    @private_elements = MediaElement.order('created_at DESC').where(:user_id => current_user.id, :is_public => false, :converted => true)
  end
  
  def quick_upload
    @file = current_user.save_in_admin_quick_uploading_cache params[:media], params[:title], params[:description], params[:tags]
  end
  
  def quick_upload_delete
    @key = :"#{params[:key]}"
    @ok = current_user.remove_from_admin_quick_uploading_cache @key
  end
  
  def create
    @key = :"#{params[:key]}"
    @ok = true
    filename = File.basename(params[:media])
    if !filename.nil?
      me = MediaElement.new :media => File.open(Rails.root.join("public/admin/#{current_user.id}/#{filename}"))
      me.title = params[:title]
      me.description = params[:description]
      me.tags = params[:tags]
      me.user_id = current_user.id
      @saved = me.save
      if !@saved
        fields = me.errors.messages.keys
        if fields.include? :sti_type
          fields << :media if !fields.include? :media
          fields.delete :sti_type
        end
        @error_fields = []
        fields.each do |f|
          @error_fields << f.to_s
        end
        @ok = false if @error_fields.empty?
      else
        if params.has_key? :publish
          me = MediaElement.find me.id
          me.is_public = true
          me.publication_date = Time.zone.now
          @ok = me.save
        end
        current_user.remove_from_admin_quick_uploading_cache(@key)
      end
    else
      @ok = false
    end
  end
  
  def update
    if @ok
      @media_element.title = params[:title]
      @media_element.description = params[:description]
      @media_element.tags = params[:tags]
      if !@media_element.save
        @errors = convert_item_error_messages @element.errors.messages
        @error_fields = @element.errors.messages.keys
      end
    end
  end
  
  def destroy
    @element.destroyable_even_if_public = true
    if !@element.destroy
      @errors = @element.get_base_error
    end
  end
  
  def load_media_element
  end
  
  private
  
  def find_element
    @element = MediaElement.find(params[:id])
  end
  
end
