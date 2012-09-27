require 'test_helper'

class SchoolLevelTest < ActiveSupport::TestCase
  
  def setup
    begin
      @school_level = SchoolLevel.new :description => 'Scuola Primaria'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @school_level = nil
    end
  end
  
  test 'null' do
    assert !@school_level.nil?
    @school_level = SchoolLevel.new
    assert_error_size 1, @school_level
  end
  
  test 'types' do
    assert_invalid @school_level, :description, long_string(256), long_string(255), /is too long/
    assert_obj_saved @school_level
  end
  
end
