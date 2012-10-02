require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  
  def setup
    @notification = Notification.new
    @notification.user_id = 1
    @notification.message = 'Sei un incompetente, le tue lezioni non piacciono a nessuno!'
  end
  
  test 'empty_and_defaults' do
    @notification = Notification.new
    assert_equal false, @notification.seen
    @notification.seen = nil
    assert_error_size 5, @notification
  end
  
  test 'attr_accessible' do
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Notification.new(:seen => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Notification.new(:user_id => 1)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Notification.new(:message => 'Ciao!!')}
  end
  
  #test 'types' do
  #  assert_invalid @notification, :description, long_string(256), long_string(255), /is too long/
  #  assert_obj_saved @notification
  #end
  
  test 'association_methods' do
    assert_nothing_raised {@notification.user}
  end
  
end
