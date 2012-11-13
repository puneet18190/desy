# encoding: UTF-8
require 'test_helper'

class LessonTest < ActiveSupport::TestCase
  
  def setup
    begin
      @lesson = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
      @lesson.copied_not_modified = false
      @lesson.user_id = 1
      @lesson.tags = 'ciao, come, stai, tu?'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @lesson = nil
    end
  end
  
  test 'valid_fixtures' do
    Lesson.find([1, 2]).each do |l|
      assert l.valid?
    end
  end
  
  test 'tags' do
    @lesson.tags = 'gatto, gatto, gatto  ,   , cane, topo'
    assert !@lesson.save, "Lesson erroneously saved - #{@lesson.inspect} -- #{@lesson.tags.inspect}"
    assert_equal 1, @lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@lesson.errors.inspect}"
    assert_equal 1, @lesson.errors.messages[:tags].length
    assert_match /are not enough/, @lesson.errors.messages[:tags].first
    @lesson.tags = 'gatto, gatto  ,   , cane, topo'
    assert !@lesson.save, "Lesson erroneously saved - #{@lesson.inspect} -- #{@lesson.tags.inspect}"
    assert_equal 1, @lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@lesson.errors.inspect}"
    assert_equal 1, @lesson.errors.messages[:tags].length
    assert_match /are not enough/, @lesson.errors.messages[:tags].first
    assert_equal 7, Tag.count
    @lesson.tags = '  gatto, oRnitOrinco,   , cane, panda  '
    assert_obj_saved @lesson
    assert_equal 7, Tag.count
    @lesson.reload
    assert_tags @lesson, ['gatto', 'cane', 'ornitorinco', 'panda']
    @lesson.tags = '  gattaccio, gattaccio, panda,   , cane, ornitorinco  '
    assert_obj_saved @lesson
    assert_equal 8, Tag.count
    @lesson.reload
    assert_tags @lesson, ['gattaccio', 'cane', 'panda', 'ornitorinco']
    assert Tag.where(:word => 'gattaccio').any?
    @lesson.tags = 'gattaccio, panda, cane, trentatré trentini entrarono a trento tutti e trentatré trotterellando'
    assert !@lesson.save, "Lesson erroneously saved - #{@lesson.inspect} -- #{@lesson.tags.inspect}"
    assert_equal 1, @lesson.errors.messages.length, "A field which wasn't supposed to be affected returned error - #{@lesson.errors.inspect}"
    assert_equal 1, @lesson.errors.messages[:tags].length
    assert_match /are not enough/, @lesson.errors.messages[:tags].first
    @lesson.reload
    assert_tags @lesson, ['gattaccio', 'cane', 'panda', 'ornitorinco']
    @lesson = Lesson.find @lesson.id
    assert_obj_saved @lesson
    assert_equal 8, Tag.count
    @lesson.reload
    assert_tags @lesson, ['gattaccio', 'cane', 'panda', 'ornitorinco']
  end
  
  test 'empty_and_defaults' do
    @lesson = Lesson.new
    assert_equal false, @lesson.is_public
    @lesson.is_public = nil
    @lesson.token = 'prova'
    assert_error_size 14, @lesson
    assert @lesson.token != 'prova'
    assert_equal 20, @lesson.token.length
  end
  
  test 'attr_accessible' do
    assert !@lesson.nil?
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:is_public => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:copied_not_modified => true)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:parent_id => 2)}
    assert_raise(ActiveModel::MassAssignmentSecurity::Error) {Lesson.new(:user_id => 1)}
  end
  
  test 'types' do
    assert_invalid @lesson, :user_id, 'er', 1, /is not a number/
    assert_invalid @lesson, :school_level_id, 0, 2, /must be greater than 0/
    assert_invalid @lesson, :subject_id, 0.6, 1, /must be an integer/
    assert_invalid @lesson, :parent_id, 'oip', nil, /is not a number/
    assert_invalid @lesson, :parent_id, -6, nil, /must be greater than 0/
    assert_invalid @lesson, :parent_id, 5.5, nil, /must be an integer/
    assert_invalid @lesson, :is_public, nil, false, /is not included in the list/
    assert_invalid @lesson, :copied_not_modified, nil, false, /is not included in the list/
    assert_invalid @lesson, :title, long_string(41), long_string(40), /is too long/
    assert_invalid @lesson, :description, long_string(281), long_string(280), /is too long/
    assert_obj_saved @lesson
  end
  
  test 'parent_id' do
    assert_invalid @lesson, :parent_id, 1000, 1, /doesn't exist/
    assert_obj_saved @lesson
    assert_invalid @lesson, :parent_id, @lesson.id, 1, /can't be the lesson itself/
    @lesson2 = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    @lesson2.copied_not_modified = false
    @lesson2.user_id = 1
    @lesson2.tags = 'ehilà, ohilà, ehi, ciao'
    assert_invalid @lesson2, :parent_id, 1, @lesson.id, /has already been taken/
    assert_obj_saved @lesson2
  end
  
  test 'automatic_cover' do
    assert_obj_saved @lesson
    assert_equal 1, Slide.where(:lesson_id => @lesson.id, :kind => 'cover').length
  end
  
  test 'association_methods' do
    assert_nothing_raised {@lesson.user}
    assert_nothing_raised {@lesson.subject}
    assert_nothing_raised {@lesson.school_level}
    assert_nothing_raised {@lesson.bookmarks}
    assert_nothing_raised {@lesson.likes}
    assert_nothing_raised {@lesson.reports}
    assert_nothing_raised {@lesson.taggings}
    assert_nothing_raised {@lesson.slides}
    assert_nothing_raised {@lesson.virtual_classroom_lessons}
    assert_nothing_raised {@lesson.parent}
    assert_nothing_raised {@lesson.copies}
  end
  
  test 'associations' do
    assert_invalid @lesson, :user_id, 1000, 1, /doesn't exist/
    assert_invalid @lesson, :school_level_id, 1000, 2, /doesn't exist/
    assert_invalid @lesson, :subject_id, 1000, 1, /doesn't exist/
    assert_obj_saved @lesson
  end
  
  test 'booleans' do
    assert_invalid @lesson, :is_public, true, false, /can't be true for new records/
    assert_obj_saved @lesson
    @lesson.is_public = true
    assert @lesson.valid?
    assert_invalid @lesson, :copied_not_modified, true, false, /can't be true if public/
    assert_obj_saved @lesson
  end
  
  test 'token_length' do
    assert_obj_saved @lesson
    old_token = @lesson.token
    assert_invalid @lesson, :token, long_string(21), old_token, /is the wrong length/
    assert_invalid @lesson, :token, long_string(19), old_token, /is the wrong length/
    assert_obj_saved @lesson
  end
  
  test 'impossible_changes' do
    @lesson.parent_id = 1
    assert_obj_saved @lesson
    assert_invalid @lesson, :user_id, 2, 1, /can't be changed/
    old_token = @lesson.token
    last_char = old_token.split(old_token.chop)[1]
    different_token = last_char == 'a' ? "#{old_token.chop}b" : "#{old_token.chop}b"
    assert_equal 20, different_token.length
    assert different_token != old_token
    assert_invalid @lesson, :token, different_token, old_token, /can't be changed/
    assert_invalid @lesson, :parent_id, 2, 1, /can't be changed/
    assert_obj_saved @lesson
  end
  
  test 'fathers_and_sons' do
    lesson3 = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    lesson3.copied_not_modified = false
    lesson3.user_id = 1
    lesson3.parent_id = 1
    lesson3.tags = 'ehilà, ohilà, ehi, ciao'
    assert_obj_saved lesson3
    lesson4 = Lesson.new :subject_id => 1, :school_level_id => 2, :title => 'Fernandello mio', :description => 'Voglio divenire uno scienziaaato'
    lesson4.copied_not_modified = false
    lesson4.user_id = 2
    lesson4.parent_id = 1
    lesson4.tags = 'ehilà, ohilà, ehi, ciao'
    assert_obj_saved lesson4
    @lesson = Lesson.find 1
    lesson4 = Lesson.find lesson4.id
    lesson3 = Lesson.find lesson3.id
    copies = @lesson.copies.sort
    parent4 = lesson4.parent
    parent3 = lesson3.parent
    assert_equal 2, copies.length
    assert_equal lesson4.id, copies.last.id
    assert_equal lesson3.id, copies.first.id
    assert_equal 1, parent4.id
    assert_equal 1, parent3.id
  end
  
end
