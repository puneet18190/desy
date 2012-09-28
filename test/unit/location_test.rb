require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  
  def setup
    begin
      @location = Location.new :description => 'Scuola Primaria'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @location = nil
    end
  end
  
  test 'empty_and_defaults' do
    @location = Location.new
    assert_error_size 1, @location
  end
  
  test 'attr_accessible' do
    assert !@location.nil?
  end
  
  test 'types' do
    assert_invalid @location, :description, long_string(256), long_string(255), /is too long/
    assert_obj_saved @location
  end
  
  test 'association_methods' do
    assert_nothing_raised {@location.users}
  end
  
end
