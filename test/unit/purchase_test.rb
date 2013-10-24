require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  
  def setup
    begin
      @purchase = Purchase.new :name => 'Scuola Media Pinco Pallino', :responsible => 'Pino Cammino', :phone_number => '0044/0678079087', :fax => '89-24-24',
                               :email => 'pino.cammino@pincopallino.it', :ssn_code => 'CMMPNI76B12H501N', :vat_code => '1231443534234235', :address => 'via del Corso 134',
                               :postal_code => '00100', :city => 'Roma', :country => 'Italia', :location_id => 1, :accounts_number => 100, :includes_invoice => true,
                               :release_date => '2012-01-01 10:00:00', :start_date => '2012-01-01 11:00:00', :expiration_date => '2013-01-01 10:59:59'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @purchase = nil
    end
  end
  
  test 'empty_and_defaults' do
    @purchase = Purchase.new
    assert_error_size 12, @purchase
  end
  
  test 'attr_accessible' do
    assert !@purchase.nil?
  end
  
  test 'types' do
    assert_invalid_email @purchase
    # TODO
    assert_obj_saved @purchase
    @purchase.location_id = nil
    assert_obj_saved @purchase
  end
  
  test 'associations' do
    # TODO
  end
  
  test 'association_methods' do
    assert_nothing_raised {@purchase.users}
    assert_nothing_raised {@purchase.location}
  end
  
  test 'dates' do
    # TODO
  end
  
  test 'at_least_one_code' do
    # TODO
  end
  
end
