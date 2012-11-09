ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  
  fixtures :all
  
  def assert_tags(item, tags)
    tags2 = []
    item.taggings.each do |t|
      tags2 << t.tag.word
    end
    assert_equal tags2.sort, tags.sort
  end
  
  def assert_ordered_item_extractor(x1, x2)
    assert_equal x1.length, x2.length, "Error, #{x1.inspect} -- #{x2.inspect}"
    cont = 0
    while cont < x1.length
      assert_equal x1[cont], x2[cont].id, "Error, #{x1.inspect} -- #{x2.inspect}"
      assert !x2[cont].status.nil?
      cont += 1
    end
  end
  
  def assert_extractor_intersection(x1, x2)
    x2.each do |y|
      flag = true
      x1.each do |x|
        flag = false if x.id == y.id
      end
      assert flag
    end
  end
  
  def assert_extractor(my_ids, resp)
    ids = []
    resp.each do |r|
      ids << r.id
    end
    assert_equal ids.sort, my_ids.sort
  end
  
  def assert_item_extractor(my_ids, resp)
    ids = []
    resp.each do |r|
      assert !r.status.nil?
      ids << r.id
    end
    assert_equal ids.sort, my_ids.sort
  end
  
  def array_to_string(array)
    resp = ''
    if !array.nil?
      array.each do |a|
        resp = "#{resp}#{a.to_s}"
      end
    end
    resp
  end
  
  def assert_invalid(obj, field, before, after, match)
    obj[field] = before
    assert !obj.save, "#{obj.class} erroneously saved - #{obj.inspect}"
    assert_equal 1, obj.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{obj.errors.inspect}"
    assert_match match, array_to_string(obj.errors.messages[field])
    obj[field] = after
    assert obj.valid?, "#{obj.class} not valid: #{obj.errors.inspect}"
  end
  
  def assert_obj_saved(obj)
    assert obj.save, "Error saving #{obj.class}: #{obj.errors.inspect}"
  end
  
  def assert_error_size(x, obj)
    assert !obj.valid?, "#{obj.class} valid when not expected! #{obj.inspect}"
    assert_equal x, obj.errors.size, "Expected #{x} errors, got #{obj.errors.size}: #{obj.errors.inspect}"
  end
  
  def assert_default(x, obj, field)
    assert_equal obj[field], x, "Expected default value < #{x.inspect} > for field #{field} of object #{obj.class}, found #{obj[field].inspect}"
  end
  
  def long_string(length)
    x = ''
    i = 0
    while i < length
      x = "#{x}a"
      i += 1
    end
    x
  end
  
end
