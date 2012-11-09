# encoding: UTF-8

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  
  def setup
    begin
      @tag = Tag.new :word => 'passerotto'
    rescue ActiveModel::MassAssignmentSecurity::Error
      @tag = nil
    end
  end
  
  test 'empty_and_defaults' do
    @tag = Tag.new
    assert_error_size 2, @tag
  end
  
  test 'attr_accessible' do
    assert !@tag.nil?
  end
  
  test 'types' do
    assert_invalid @tag, :word, long_string(26), long_string(25), /is too long/
    assert_invalid @tag, :word, '', 'uu', /is too short/
    assert_obj_saved @tag
  end
  
  test 'uniqueness' do
    assert_invalid @tag, :word, 'squalo', 'passerotto', /has already been taken/
    assert_obj_saved @tag
  end
  
  test 'association_methods' do
    assert_nothing_raised {@tag.taggings}
  end
  
  test 'lowercase' do
    @tag.word = '     ÀÁÄÂCaNaRiNo  ËÏÖÜ     a '
    assert_obj_saved @tag
    @tag = Tag.find @tag.id
    assert_equal 'àáäâcanarino  ëïöü     a', @tag.word
  end
  
  test 'impossible_changes' do
    @tag.word = 'ciao'
    assert_obj_saved @tag
    assert_invalid @tag, :word, 'cia', 'ciao', /can't be changed/
    assert_obj_saved @tag
  end
  
end
