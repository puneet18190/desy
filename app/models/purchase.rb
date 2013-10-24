# == Description
#
# ActiveRecord class that corresponds to the table +purchases+.
#
# == Fields
#
# * *name*: name of the buyer
# * *responsible*: name and surname of the person who is responsible for the transaction
# * *phone_number*: phone number of the responsible
# * *fax*: fax of the responsible
# * *email*: official email of the buyer
# * *ssn_code*: personal code
# * *vat_code*: code of the company
# * *address*: address of the buyer
# * *postal_code*: postal code of the buyer
# * *city*: city of the buyer
# * *country*: country of the buyer
# * *accounts_number*: how many accounts are associated to this purchase
# * *includes_invoice*: if true, the purchae must be associated to an invoice (not implemented in the application)
# * *release_date*: date of purchase
# * *start_date*: date of beginning of the validity of the purchase
# * *expiration_date*: expiration date of the purchase
# * *location_id*: location which must be forced to the users who benefit this purchase
#
# == Associations
#
# * *users*: users associated to this purchase (see User) (*has_many*)
# * *location*: location to which all the user must belong (this is not inserted into a validation, not to overload the model, but just in the methods for the frontend) (*belongs_to*, it can be nil)
#
# == Validations
#
# * *presence* of +name+, +responsible+, +email+, +accounts_number+, +release_date+, +start_date+, +expiration_date+
# * *numericality* greater than 0 for +accounts_number+
# * *numericality* greater than 0 and allow_nil and eventually presence of associated object for +location_id+
# * *length* of +name+, +responsible+, +phone_number+, +fax+, +email+, +ssn_code+, +vat_code+, +address+, +postal_code+, +city+, +country+ (maximum 255)
# * *inclusion* of +includes_invoice+ in [true, false]
# * *correctness* of +email+ as an e-mail address
# * *format* of dates +release_date+, +start_date+, +expiration_date+
# * *presence* of at least one between +vat_code+ and +ssn_code+
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class Purchase < ActiveRecord::Base
  
  # List of attributes which are accessible for massive assignment
  ATTR_ACCESSIBLE = [:name,             :responsible,  :phone_number, :fax,
                     :email,            :ssn_code,     :vat_code,     :address,
                     :postal_code,      :city,         :country,      :accounts_number,
                     :includes_invoice, :release_date, :start_date,   :expiration_date, :location_id]
  attr_accessible *ATTR_ACCESSIBLE
  
  has_many :users
  belongs_to :location
  
  validates_presence_of :name, :responsible, :email, :accounts_number, :release_date, :start_date, :expiration_date
  validates_numericality_of :accounts_number, :greater_than => 0, :only_integer => true
  validates_numericality_of :location_id, :greater_than => 0, :only_integer => true, :allow_nil => true
  validates_length_of :name, :responsible, :phone_number, :fax, :email, :ssn_code, :vat_code, :address, :postal_code, :city, :country, :maximum => 255
  validates_inclusion_of :includes_invoice, :in => [true, false]
  
  validate :validate_email, :validate_dates, :validate_associations, :validate_codes
  
  before_validation :init_validation
  
  private
  
  # Initializes the objects needed for the validation
  def init_validation
    @purchase = Valid.get_association self, :id
    @location = Valid.get_association self, :location_id
  end
  
  # Validates that at least one between vat_code and ssn_code is present
  def validate_codes
    errors.add :base, :missing_both_codes if self.vat_code.blank? && self.ssn_code.blank?
  end
  
  # Validates the presence of associated elements
  def validate_associations
    errors.add :location_id, :doesnt_exist if @location.nil? && self.location_id.present?
  end
  
  # Validates the correct format of the email (see Valid.email?)
  def validate_email
    return if self.email.blank?
    errors.add(:email, :not_a_valid_email) if !Valid.email?(self.email)
  end
  
  # Validates the correct format of the dates
  def validate_dates
    errors.add(:release_date, :is_not_a_date) if !self.release_date.kind_of?(Time)
    errors.add(:start_date, :is_not_a_date) if !self.start_date.kind_of?(Time)
    errors.add(:expiration_date, :is_not_a_date) if !self.expiration_date.kind_of?(Time)
  end
  
end
