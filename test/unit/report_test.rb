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
  
  test 'types' do
    assert_invalid @report, :user_id, 'ehi', 1, /is not a number/
    assert_invalid @report, :reportable_id, 5.66, 1, /must be an integer/
    assert_invalid @report, :user_id, -4, 1, /must be greater than 0/
    assert_invalid @report, :reportable_type, 'Lazie', 'Lesson', /is not included in the list/
    assert_obj_saved @report
  end
  
  test 'uniqueness' do
    assert_invalid @report, :reportable_id, 2, 1, /has already been taken/
    @report.reportable_type = 'MediaElement'
    assert_invalid @report, :reportable_id, 1, 5, /has already been taken/
    # I prove that it is possible to report items not public and mine
    assert_equal 'MediaElement', @report.reportable_type
    my_reportable = MediaElement.find(@report.reportable_id)
    assert_equal @report.user_id, my_reportable.user_id
    assert !my_reportable.is_public
    assert_obj_saved @report
  end
  
  test 'associations' do
    assert_invalid @report, :user_id, 1000, 1, /doesn't exist/
    assert_invalid @report, :reportable_id, 1000, 1, /lesson doesn't exist/
    @report.reportable_type = 'MediaElement'
    assert_invalid @report, :reportable_id, 1000, 2, /media element doesn't exist/
    assert_obj_saved @report
  end
  
  test 'association_methods' do
    assert_nothing_raised {@report.user}
    assert_nothing_raised {@report.reportable}
  end
  
  test 'impossible_changes' do
    assert_obj_saved @report
    assert_invalid @report, :user_id, 2, 1, /can't be changed/
    assert_invalid @report, :reportable_id, 2, 1, /can't be changed/
    Report.where(:reportable_type => 'MediaElement', :reportable_id => 1, :user_id => 1).first.destroy
    assert_invalid @report, :reportable_type, 'MediaElement', 'Lesson', /can't be changed/
    assert_invalid @report, :comment, "Non ho d'accordo con il contenuto", "Non sono d'accordo con il contenuto", /can't be changed/
    assert_obj_saved @report
  end
  
end
