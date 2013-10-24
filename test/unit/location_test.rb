require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  
  def setup
    begin
      @location = Location.new :name => 'Prova', :code => 'asdvga'
      @location.sti_type = 'Subschool'
      @location.ancestry = '1'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @location = nil
    end
  end
  
  test 'empty_and_defaults' do
    @location = Location.new
    assert_error_size 6, @location
  end
  
  test 'attr_accessible' do
    assert !@location.nil?
  end
  
  test 'attr_accessible' do
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Location.new(:ancestry => '1')}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Location.new(:sti_type => 'Cane')}
  end
  
  test 'types' do
    assert_invalid @location, :name, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_invalid @location, :code, long_string(256), long_string(255), :too_long, {:count => 255}
    assert_obj_saved @location
    @location.code = nil
    assert_obj_saved @location
  end
  
  test 'uniqueness' do
    @location.code = 'XCMYAA'
    assert_equal 1, Location.where(:code => 'XCMYAA').count
    assert_obj_saved @location
    assert_equal 2, Location.where(:code => 'XCMYAA').count
    @location = Location.find(1)
    assert_invalid @location, :code, 'XCMYAA', 'pippo', :taken
    assert_obj_saved @location
  end
  
end
