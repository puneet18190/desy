require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  
  def setup
    begin
      @location = Location.new :description => 'Scuola Primaria'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @location = nil
    end
  end
  
  test 'null' do
    assert !@location.nil?
    @location = Location.new
    assert_error_size 1, @location
  end
  
  test 'types' do
    assert_invalid @location, :description, long_string(256), long_string(255), /is too long/
    assert_obj_saved @location
  end
  
end
