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
    renewed = Purchase.find_by_id params[:renew]
    @purchase = Purchase.new
    if renewed
      @purchase.name = renewed.name
      @purchase.responsible = renewed.responsible
      @purchase.phone_number = renewed.phone_number
      @purchase.fax = renewed.fax
      @purchase.email = renewed.email
      @purchase.ssn_code = renewed.ssn_code
      @purchase.vat_code = renewed.vat_code
      @purchase.address = renewed.address
      @purchase.postal_code = renewed.postal_code
      @purchase.city = renewed.city
      @purchase.country = renewed.country
      @purchase.includes_invoice = renewed.includes_invoice
      @purchase.release_date = Time.zone.now
      @purchase.start_date = renewed.expiration_date
    end
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
    @message = params[:message].blank? ? I18n.t('admin.purchases.links.empty_message') : params[:message]
    UserMailer.purchase_resume(params[:emails].split(','), @purchase, @message, request.host, request.port).deliver
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
