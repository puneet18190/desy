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
  
  before_filter :check_saas
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
  # * Admin::PurchaseController#check_saas
  #
  def index
    if @ok
      redirect_to '/admin'
      return
    end
    purchases = AdminSearchForm.search_purchases((params[:search] ? params[:search] : {:ordering => 0, :desc => 'true'}))
    @purchases = purchases.page(params[:page])
  end
  
  private
  
  # Filter that checks if this section is enabled
  def check_saas
    @ok = SETTINGS['saas_registration_mode']
  end
  
end
