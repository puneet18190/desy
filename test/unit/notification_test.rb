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
  
  test 'types' do
    assert_invalid @notification, :user_id, 'erw', 1, /is not a number/
    assert_invalid @notification, :user_id, 11.1, 1, /must be an integer/
    assert_invalid @notification, :user_id, 0, 1, /must be greater than 0/
    assert_invalid @notification, :seen, nil, false, /is not included in the list/
    assert_obj_saved @notification
  end
  
  test 'associations' do
    assert_invalid @notification, :user_id, 1000, 1, /doesn't exist/
    assert_obj_saved @notification
  end
  
  test 'association_methods' do
    assert_nothing_raised {@notification.user}
  end
  
  test 'initial_seen' do
    assert_invalid @notification, :seen, true, false, /must be false when new record/
    assert_obj_saved @notification
  end
  
  test 'impossible_changes' do
    assert_obj_saved @notification
    @notification.seen = true
    assert_obj_saved @notification
    assert_invalid @notification, :user_id, 2, 1, /can't be changed/
    assert_invalid @notification, :message, 'Sei un perdente, le tue lezioni non piacciono a nessuno!', 'Sei un incompetente, le tue lezioni non piacciono a nessuno!', /can't be changed/
    assert_invalid @notification, :seen, false, true, /can't be switched from true to false/
    assert_obj_saved @notification
  end
  
  test 'methods_for_controller' do
    Notification.all.each do |n|
      n.destroy
    end
    assert Notification.all.empty?
    (1...20).each do |i|
      assert Notification.send_to(1, 'cia')
      assert Notification.send_to(2, 'cia')
    end
    
    #$Notification.not_seen(an_user_id, a_limit)
    #Notification.visible_block(an_user_id, a_limit)
    #Notification.number_not_seen(an_user_id)
  end
  
end
