class DocumentsController < ApplicationController
  
  # Number of documents for each page
  FOR_PAGE = SETTINGS['documents_pagination']
  
  before_filter :initialize_document, :only => :destroy
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
