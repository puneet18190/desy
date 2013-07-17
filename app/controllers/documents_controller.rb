class DocumentsController < ApplicationController
  
  # Number of documents for each page
  FOR_PAGE = SETTINGS['documents_pagination']
  
  before_filter :initialize_document, :only => [:destroy, :update]
  before_filter :initialize_layout, :initialize_paginator, :only => :index
  
  # === Description
  #
  # Main page of the section 'documents'. When it's called via ajax it's because of the application of filters, paginations, or after an operation that changed the number of items in the page.
  #
  # === Mode
  #
  # Html + Ajax
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  # * DocumentsController#initialize_paginator
  #
  def index
    get_own_documents
    if @page > @pages_amount && @pages_amount != 0
      @page = @pages_amount
      get_own_documents
    end
    render_js_or_html_index
  end
  
  # === Description
  #
  # Deletes definitively a document.
  #
  # === Mode
  #
  # Json
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_document
  #
  def destroy
    if @ok
      if !@document.destroy_with_notifications
        @ok = false
        @error = I18n.t('activerecord.errors.models.document.problem_destroying')
      end
    else
      @error = I18n.t('activerecord.errors.models.document.problem_destroying')
    end
    render :json => {:ok => @ok, :msg => @error}
  end
  
  # === Description
  #
  # Updates the general information of the document (title and description)
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_document
  #
  def update
    if @ok
      @document.title = params[:title]
      @document.description = params[:description_placeholder].blank? ? params[:description] : ''
      if !@document.save
        @errors = convert_item_error_messages @document.errors.messages
        @error_fields = @document.errors.messages.keys
      end
    end
  end
  
  # === Description
  #
  # Action that calls the uploader and creates the new document
  #
  # === Mode
  #
  # Html
  #
  def create
    #media = params[:media]
    #record = MediaElement.new :media => media
    #record.title = params[:title_placeholder] != '0' ? '' : params[:title]
    #record.description = params[:description_placeholder] != '0' ? '' : params[:description]
    #record.tags = params[:tags_value]
    #record.user_id = current_user.id
    #record.validating_in_form = true
    #if record.save
    #  Notification.send_to current_user.id, t("notifications.#{record.class.to_s.downcase}.upload.started", item: record.title) if !record.image?
    #else
   #  if record.errors.added? :media, :too_large
   #     return render :file => Rails.root.join('public/413.html'), :layout => false, :status => 413
   #   end
   #   @errors = convert_media_element_uploader_messages record.errors
   #   fields = record.errors.messages.keys
   #   fields.delete(:media) if fields.include?(:media) && record.errors.messages[:media].empty?
   #   if fields.include? :sti_type
   #     fields << :media if !fields.include? :media
   #     fields.delete :sti_type
   #   end
   #   @error_fields = []
   #   fields.each do |f|
   #     @error_fields << f.to_s
   #   end
   # end
   # render :layout => false
  end
  
  private
  
  # Gets the documents using User#own_documents
  def get_own_documents
    current_user_own_documents = current_user.own_documents(@page, @for_page, @order, @word)
    @documents = current_user_own_documents[:records]
    @pages_amount = current_user_own_documents[:pages_amount]
  end
  
  # Initializes pagination parameters and filters
  def initialize_paginator
    @page = correct_integer?(params[:page]) ? params[:page].to_i : 1
    @for_page = FOR_PAGE
    @order = SearchOrders::DOCUMENTS_SET.include?(params[:order]) ? params[:order] : SearchOrders::CREATED_AT
    @word = params[:word].blank? ? nil : params[:word]
  end
  
end
