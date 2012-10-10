require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  
  test 'lesson' do
    l1 = Lesson.find 1
    l2 = Lesson.find 2
    assert l1.status.nil?
    assert l1.buttons.empty?
    l1.set_status 1
    assert_equal 'private', l1.status
    assert_equal ['preview', 'edit', 'publish', 'virtual_classroom', 'destroy', 'copy'], l1.buttons
    l1.set_status 2
    assert l1.status.nil?
    assert l1.buttons.empty?
    assert l1.publish
    l1.set_status 1
    assert_equal 'public', l1.status
    assert_equal ['preview', 'unpublish', 'virtual_classroom', 'edit', 'destroy', 'copy'], l1.buttons
    l1.set_status 2
    assert_equal 'not mine', l1.status
    assert_equal ['preview', 'like', 'add', 'report'], l1.buttons
    assert User.find(2).bookmark('Lesson', 1)
    l1.set_status 2
    assert_equal 'linked', l1.status
    assert_equal ['preview', 'virtual_classroom', 'remove', 'copy', 'like', 'report'], l1.buttons
    l3 = l1.copy(2)
    assert !l3.nil?
    l3.set_status 2
    assert_equal 'copied', l3.status
    assert_equal ['preview', 'edit', 'destroy'], l3.buttons
  end
  
end
