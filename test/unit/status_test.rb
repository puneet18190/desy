require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  
  test 'lesson' do
    l1 = Lesson.find 1
    assert l1.status.nil?
    assert l1.buttons.empty?
    l1.set_status 1
    assert_equal 'private', l1.status
    assert_equal ['preview', 'edit', 'publish', 'add_virtual_classroom', 'destroy', 'copy'], l1.buttons
    # I try add_to_virtual_classroom
    assert l1.add_to_virtual_classroom(1)
    l1.set_status 1
    assert_equal 'private', l1.status
    assert_equal ['preview', 'edit', 'publish', 'remove_virtual_classroom', 'destroy', 'copy'], l1.buttons
    # until here
    l1.set_status 2
    assert l1.status.nil?
    assert l1.buttons.empty?
    assert l1.publish
    l1.set_status 1
    assert_equal 'public', l1.status
    assert_equal ['preview', 'unpublish', 'remove_virtual_classroom', 'edit', 'destroy', 'copy'], l1.buttons
    l1.set_status 2
    assert_equal 'not mine', l1.status
    assert_equal ['preview', 'like', 'add', 'report'], l1.buttons
    # I try like
    assert User.find(2).like(l1.id)
    l1.set_status 2
    assert_equal 'not mine', l1.status
    assert_equal ['preview', 'dislike', 'add', 'report'], l1.buttons
    # until here
    assert User.find(2).bookmark('Lesson', 1)
    l1.set_status 2
    assert_equal 'linked', l1.status
    assert_equal ['preview', 'add_virtual_classroom', 'remove', 'copy', 'dislike', 'report'], l1.buttons
    l3 = l1.copy(2)
    assert !l3.nil?
    l3.set_status 2
    assert_equal 'copied', l3.status
    assert_equal ['preview', 'edit', 'destroy'], l3.buttons
  end
  
  test 'media_element' do
    me1 = MediaElement.find 1
    assert me1.status.nil?
    assert me1.buttons.empty?
    me1.set_status 1
    assert_equal 'private', me1.status
    assert_equal ['preview', 'edit', 'destroy', 'change_info'], me1.buttons
    me1.set_status 2
    assert me1.status.nil?
    assert me1.buttons.empty?
    me1.is_public = true
    me1.publication_date = '2011-01-01 00:00:01'
    assert_obj_saved me1
    me1.set_status 1
    assert_equal 'not mine', me1.status
    me1.set_status 2
    assert_equal 'not mine', me1.status
    assert_equal ['preview', 'add', 'report'], me1.buttons
    assert User.find(2).bookmark('MediaElement', 1)
    me1.set_status 2
    assert_equal 'linked', me1.status
    assert_equal ['preview', 'edit', 'remove', 'report'], me1.buttons
  end
  
end
