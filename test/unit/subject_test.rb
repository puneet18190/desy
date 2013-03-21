require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  
  def setup
    begin
      @subject = Subject.new :description => 'Scuola Primaria'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @subject = nil
    end
  end
  
  test 'empty_and_defaults' do
    @subject = Subject.new
    assert_error_size 1, @subject
  end
  
  test 'attr_accessible' do
    assert !@subject.nil?
  end
  
  test 'types' do
    assert_invalid @subject, :description, long_string(256), long_string(255), :too_long
    assert_obj_saved @subject
  end
  
  test 'association_methods' do
    assert_nothing_raised {@subject.users_subjects}
    assert_nothing_raised {@subject.lessons}
  end
  
end
