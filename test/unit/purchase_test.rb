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
    assert_error_size 13, @purchase
  end
  
  test 'attr_accessible' do
    assert !@purchase.nil?
  end
  
  test 'types' do
    assert_invalid_email @purchase
    assert_invalid @purchase, :accounts_number, 'et', 1, :not_a_number
    assert_invalid @purchase, :accounts_number, 0, 1, :greater_than, {:count => 0}
    assert_invalid @purchase, :accounts_number, 1.1, 1, :not_an_integer
    assert_invalid @purchase, :location_id, 'et', 1, :not_a_number
    assert_invalid @purchase, :location_id, 0, 1, :greater_than, {:count => 0}
    assert_invalid @purchase, :location_id, 1.1, 1, :not_an_integer
    assert_invalid @purchase, :name, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :responsible, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :phone_number, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :fax, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :email, (long_string(248) + '@ciao.it'), (long_string(247) + '@ciao.it'), :too_long, {:count => 255}
    assert_invalid @purchase, :ssn_code, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :vat_code, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :address, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :postal_code, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :city, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :country, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @purchase, :includes_invoice, nil, false, :inclusion
    assert_invalid @purchase, :release_date, 1, '2012-01-01 10:00:00', :is_not_a_date
    assert_invalid @purchase, :start_date, 1, '2012-01-01 10:00:00', :is_not_a_date
    assert_invalid @purchase, :expiration_date, 1, '2012-01-01 10:00:00', :is_not_a_date
    assert_obj_saved @purchase
    @purchase.location_id = nil
    assert_obj_saved @purchase
  end
  
  test 'associations' do
    assert_invalid @purchase, :location_id, 1000, 1, :doesnt_exist
    assert_obj_saved @purchase
  end
  
  test 'association_methods' do
    assert_nothing_raised {@purchase.users}
    assert_nothing_raised {@purchase.location}
  end
  
  test 'at_least_one_code' do
    @purchase.vat_code = nil
    @purchase.ssn_code = nil
    assert !@purchase.save, "Purchase erroneously saved - #{@purchase.inspect}"
    assert_equal 1, @purchase.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@purchase.errors.inspect}"
    assert @purchase.errors.added? :base, :missing_both_codes
    @purchase.vat_code = 'dsgdsg'
    assert @purchase.valid?, "Purchase not valid: #{@purchase.errors.inspect}"
    @purchase.vat_code = nil
    @purchase.ssn_code = 'dsgdsg'
    assert @purchase.valid?, "Purchase not valid: #{@purchase.errors.inspect}"
  end
  
  test 'impossible_changes' do
    assert_obj_saved @purchase
    assert_invalid @purchase, :accounts_number, 2, 10, :cant_be_changed
    assert_obj_saved @purchase
  end
  
end
