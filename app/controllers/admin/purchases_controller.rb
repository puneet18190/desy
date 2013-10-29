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
    if !@ok
      redirect_to '/admin'
      return
    end
    purchases = AdminSearchForm.search_purchases((params[:search] ? params[:search] : {:ordering => 0, :desc => 'true'}))
    @purchases = purchases.page(params[:page])
  end
  
  # === Description
  #
  # Form to create a new purchase
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
  def new
  end
  
  # === Description
  #
  # Action to send to a list of emails the instructions to use the purchase code
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
  def send_link
    @purchase = Purchase.find_by_id params[:id]
    if !@purchase
      redirect_to '/admin/purchases'
      return
    end
    UserMailer.purchase_resume(params[:emails].split(','), @purchase, params[:message], request.host, request.port).deliver
    redirect_to '/admin/purchases'
  end
  
  # === Description
  #
  # Form to send to a list of emails the instructions to use the purchase code
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
  def link_form
    @purchase = Purchase.find_by_id params[:id]
    if !@purchase
      redirect_to '/admin/purchases'
      return
    end
  end
  
  private
  
  # Filter that checks if this section is enabled
  def check_saas
    @ok = SETTINGS['saas_registration_mode']
  end
  
end
