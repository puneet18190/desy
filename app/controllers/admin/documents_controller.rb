# == Description
#
# Controller of documents in the administration section. See AdminController.
#
# == Models used
#
# * Document
# * AdminSearchForm
#
class Admin::DocumentsController < AdminController
  
  layout 'admin'
  
  # === Description
  #
  # Main page of documents in the admin. If params[:search] is present, it is used AdminSearchForm to perform the requested search.
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def index
    documents = params[:search] ? AdminSearchForm.search_documents(params[:search]) : Document.order('id DESC')
    @documents = documents.page(params[:page])
  end
  
  # === Description
  #
  # Destroys a document, sending notifications if it's used in somebody's lessons.
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def destroy
    @document = Document.find(params[:id])
    @element.destroy
    redirect_to params[:back_url]
  end
  
end
