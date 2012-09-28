require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  
  def setup
    begin
      @subject = Subject.new :description => 'Scuola Primaria'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @subject = nil
    end
  end
  
  test 'null' do
    assert !@subject.nil?
    @subject = Subject.new
    assert_error_size 1, @subject
  end
  
  test 'types' do
    assert_invalid @subject, :description, long_string(256), long_string(255), /is too long/
    assert_obj_saved @subject
  end
  
end
