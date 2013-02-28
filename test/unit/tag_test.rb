# encoding: UTF-8

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  
  def load_tags
    me = MediaElement.all
    me[0].tags = 'pane, pagliaccio, cane, cagnaccio'
    assert_obj_saved me[0]
    me[1].tags = 'paglierino, pappardelle, cane, cagnaccio'
    assert_obj_saved me[1]
    me[2].tags = 'pappardelle, pagliaccio, cagnolino, candreva'
    assert_obj_saved me[2]
    me[3].tags = 'pane, paniere, paglierino, pagnotta'
    assert_obj_saved me[3]
    me[4].tags = 'cagnolino, cagnetto, cane, cagnaccio'
    assert_obj_saved me[4]
    me[5].tags = 'paniere, pagnotta, pane, pagliaccio'
    assert_obj_saved me[5]
    le = Lesson.all
    le[0].tags = 'paniere, pane, cagnaccio, pagliaccio'
    assert_obj_saved le[0]
    le[1].tags = 'pane e salame, pagnotta, pane, cagnolino, pa, ca'
    assert_obj_saved le[1]
    assert_equal 14, Tag.count
    tag_ca = Tag.find_by_word 'ca'
    assert_equal 1, tag_ca.taggings.count
    tag_pa = Tag.find_by_word 'pa'
    assert_equal 1, tag_pa.taggings.count
  end
  
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
  
  test 'autocomplete' do
    load_tags
    assert_words_ordered Tag.get_tags_for_autocomplete('pa'), ['pa', 'pane', 'pagliaccio', 'pagnotta', 'paniere', 'paglierino', 'pappardelle', 'pane e salame']
    assert_words_ordered Tag.get_tags_for_autocomplete('ca'), ['ca', 'cagnaccio', 'cagnolino', 'cane', 'cagnetto', 'candreva']
    assert_words_ordered Tag.get_tags_for_autocomplete('can'), ['cane', 'candreva']
    assert_words_ordered Tag.get_tags_for_autocomplete('pan'), ['pane', 'paniere', 'pane e salame']
    assert Tag.get_tags_for_autocomplete('').empty?
  end
  
  test 'for_search_engine' do
    load_tags
    MediaElement.where('id < 7').update_all(:user_id => 1, :is_public => false)
    Lesson.where('id < 3').update_all(:user_id => 1, :is_public => false)
    user = User.find 1
    MediaElement.all.each do |me|
      assert !me.is_public && me.user_id == 1
      assert user.create_lesson(me.title, me.description, 1, me.tags)
    end
    Lesson.all.each do |l|
      assert !l.is_public && l.user_id == 1
      v = Video.new :title => l.title, :description => l.description
      v.user_id = 1
      v.tags = l.tags
      v.media = {:mp4 => Rails.root.join("test/samples/one.mp4").to_s, :webm => Rails.root.join("test/samples/one.webm").to_s, :filename => "video_test"}
      assert_obj_saved v
    end
    assert_tags_ordered user.search_lessons('pa', 1, 20)[:tags], ['pa', 'pane', 'pagliaccio', 'pagnotta', 'paniere', 'paglierino', 'pappardelle', 'pane e salame']
    assert_tags_ordered user.search_lessons('ca', 1, 20)[:tags], ['ca', 'cagnaccio', 'cagnolino', 'cane', 'cagnetto', 'candreva']
    assert_tags_ordered user.search_lessons('can', 1, 20)[:tags], ['cane', 'candreva']
    assert_tags_ordered user.search_lessons('pan', 1, 20)[:tags], ['pane', 'paniere', 'pane e salame']
    assert_tags_ordered user.search_media_elements('pa', 1, 20)[:tags], ['pa', 'pane', 'pagliaccio', 'pagnotta', 'paniere', 'paglierino', 'pappardelle', 'pane e salame']
    assert_tags_ordered user.search_media_elements('ca', 1, 20)[:tags], ['ca', 'cagnaccio', 'cagnolino', 'cane', 'cagnetto', 'candreva']
    assert_tags_ordered user.search_media_elements('can', 1, 20)[:tags], ['cane', 'candreva']
    assert_tags_ordered user.search_media_elements('pan', 1, 20)[:tags], ['pane', 'paniere', 'pane e salame']
  end
  
end
