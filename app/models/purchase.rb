class Purchase < ActiveRecord::Base
  
  # List of attributes which are accessible for massive assignment
  ATTR_ACCESSIBLE = [:name,             :responsible,  :phone_number, :fax,
                     :email,            :ssn_code,     :vat_code,     :address,
                     :postal_code,      :city,         :country,      :accounts_number,
                     :includes_invoice, :release_date, :start_date,   :expiration_date, :location_id,]
  attr_accessible *ATTR_ACCESSIBLE
  
  has_many :users
  belongs_to :location
  
  validates_presence_of :name, :responsible, :email, :accounts_number, :release_date, :start_date, :expiration_date
  validates_numericality_of :accounts_number, :greater_than => 0, :only_integer => true
  validates_numericality_of :location_id, :greater_than => 0, :only_integer => true, :allow_nil => true
  validates_length_of :name, :responsible, :phone_number, :fax, :email, :ssn_code, :vat_code, :address, :postal_code, :city, :country, :maximum => 255
  validates_inclusion_of :includes_invoice, :in => [true, false]
  
  validate :validate_email, :validate_dates, :validate_associations # TODO manca validazione che almeno uno dei codici sia presente
  
  before_validation :init_validation
  
  private
  
  # Initializes the objects needed for the validation
  def init_validation
    @purchase = Valid.get_association self, :id
    @location = Valid.get_association self, :location_id
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
