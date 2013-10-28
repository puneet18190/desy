# == Description
#
# Controller of purchases in the administration section. See AdminController.
#
# == Models used
#
# * AdminSearchForm
# * Purchase
# * Location
#
class Admin::PurchasesController < AdminController
  
  layout 'admin'
  
  # === Description
  #
  # Main page of the section 'purchases' in admin. If params[:search] is present, it is used AdminSearchForm to perform the requested search.
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
    purchases = AdminSearchForm.search_purchases((params[:search] ? params[:search] : {:ordering => 0, :desc => 'true'}))
    @purchases = purchases.page(params[:page])
  end
  
end
