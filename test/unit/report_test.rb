require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  
  def setup
    @report = Report.new
    @report.user_id = 1
    @report.reportable_type = 'Lesson'
    @report.reportable_id = 1
    @report.comment = "Non sono d'accordo con il contenuto"
  end
  
  test 'empty_and_defaults' do
    @report = Report.new
    assert_error_size 7, @report
  end
  
  test 'attr_accessible' do
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Report.new(:user_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Report.new(:reportable_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Report.new(:reportable_type => 'MediaElement')}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Report.new(:comment => 'Fa schifo!')}
  end
  
  #test 'types' do
  #  assert_invalid @report, :description, long_string(256), long_string(255), /is too long/
  ##  assert_obj_saved @report
  #end
  
  test 'association_methods' do
    assert_nothing_raised {@report.user}
    assert_nothing_raised {@report.reportable}
  end
  
end
