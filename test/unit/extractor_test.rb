# encoding: UTF-8

require 'test_helper'

class ExtractorTest < ActiveSupport::TestCase
  
  def load_likes
    Like.all.each do |l|
      l.destroy
    end
    @liker1 = User.create_user('em1@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker2 = User.create_user('em2@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker3 = User.create_user('em3@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker4 = User.create_user('em4@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker5 = User.create_user('em5@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker6 = User.create_user('em6@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker7 = User.create_user('em7@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker8 = User.create_user('em8@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    @liker9 = User.create_user('em9@em.em', 'dgdsg', 'sdgds', 'adgadg', 1, 1, [1])
    assert @liker1.like @les1.id
    assert @liker1.like @les3.id
    assert @liker1.like @les6.id
    assert @liker1.like @les9.id
    assert @liker2.like @les2.id
    assert @liker2.like @les3.id
    assert @liker2.like @les4.id
    assert @liker2.like @les7.id
    assert @liker3.like @les1.id
    assert @liker4.like @les4.id
    assert @liker4.like @les8.id
    assert @liker5.like @les5.id
    assert @liker5.like @les6.id
    assert @liker5.like @les7.id
    assert @liker6.like @les8.id
    assert @liker6.like @les1.id
    assert @liker6.like @les3.id
    assert @liker7.like @les1.id
    assert @liker7.like @les5.id
    assert @liker7.like @les6.id
    assert @liker8.like @les8.id
    assert @liker9.like @les8.id
    assert @liker9.like @les1.id
  end
  
  def populate_tags
    Tag.all.each do |t|
      t.destroy
    end
    tags = []
    tags << "cane"
    tags << "sole"
    tags << "gatto"
    tags << "cincillà"
    tags << "walter nudo"
    tags << "luna"
    tags << "escrementi di usignolo"
    tags << "disabili"
    tags << "barriere architettoniche"
    tags << "mare"
    tags << "petrolio"
    tags << "sostenibilità"
    tags << "immondizia"
    tags << "inquinamento atmosferico"
    tags << "inquinamento"
    tags << "pollution"
    tags << "tom cruise"
    tags << "cammello"
    tags << "cammelli"
    tags << "acqua"
    tags << "acquario"
    tags << "acquatico"
    tags << "個名"
    tags << "拿大即"
    tags << "河"
    tags << "條聖"
    tags << "係英國"
    tags << "拿"
    tags << "住羅倫"
    tags << "加"
    tags << "大湖"
    tags << "咗做"
    tags << "個"
    tags << "法屬係話"
    tag_ids = []
    tags.each do |t|
      tt = Tag.new
      tt.word = t
      tt.save
      tag_ids << tt.id
    end
    tag_map = {
      0 => [tag_ids[0], tag_ids[1], tag_ids[2], tag_ids[3], tag_ids[4], tag_ids[5], tag_ids[6]],
      1 => [tag_ids[4], tag_ids[5], tag_ids[6], tag_ids[7], tag_ids[8], tag_ids[9], tag_ids[10]],
      2 => [tag_ids[8], tag_ids[9], tag_ids[10], tag_ids[11], tag_ids[12], tag_ids[13], tag_ids[14]],
      3 => [tag_ids[14], tag_ids[15], tag_ids[16], tag_ids[17], tag_ids[18], tag_ids[19], tag_ids[20]],
      4 => [tag_ids[18], tag_ids[19], tag_ids[20], tag_ids[21], tag_ids[22], tag_ids[23], tag_ids[24]],
      5 => [tag_ids[22], tag_ids[23], tag_ids[24], tag_ids[25], tag_ids[26], tag_ids[27], tag_ids[28]],
      6 => [tag_ids[26], tag_ids[27], tag_ids[28], tag_ids[29], tag_ids[30], tag_ids[31], tag_ids[32]],
      7 => [tag_ids[30], tag_ids[31], tag_ids[32], tag_ids[33], tag_ids[0], tag_ids[1], tag_ids[2]],
      8 => [tag_ids[2], tag_ids[5], tag_ids[8], tag_ids[11], tag_ids[14], tag_ids[17], tag_ids[20]],
      9 => [tag_ids[6], tag_ids[13], tag_ids[20], tag_ids[27], tag_ids[4], tag_ids[9], tag_ids[14]]
    }
    cont = 0
    MediaElement.all.each do |me|
      assert Tag.create_tag_set('MediaElement', me.id, tag_map[cont%10]), "Tags not saved for MediaElement -- #{me.inspect}"
      cont += 1
    end
    Lesson.all.each do |l|
      assert Tag.create_tag_set('Lesson', l.id, tag_map[cont%10]), "Tags not saved for Lesson -- #{l.inspect}"
      cont += 1
    end
  end
  
  def setup
    @user1 = User.find 1
    assert @user1.edit_fields 'a_name', 'a_surname', 'a_school', @user1.school_level_id, @user1.location_id, [1, 2, 3, 4, 5, 6]
    @user2 = User.find 2
    assert @user2.edit_fields 'a_name', 'a_surname', 'a_school', @user2.school_level_id, @user2.location_id, [1, 2, 3, 4]
    # LESSONS
    @les1 = @user1.create_lesson('title1', 'desc1', 1)
    @les2 = @user1.create_lesson('title2', 'desc2', 2)
    @les3 = @user1.create_lesson('title3', 'desc3', 3)
    @les4 = @user1.create_lesson('title4', 'desc4', 4)
    @les5 = @user1.create_lesson('title5', 'desc5', 5)
    @les6 = @user1.create_lesson('title6', 'desc6', 6)
    @les7 = @user1.create_lesson('title7', 'desc7', 1)
    @les8 = @user1.create_lesson('title8', 'desc8', 2)
    @les9 = @user1.create_lesson('title9', 'desc9', 3)
    assert_equal 11, Lesson.count, "Error, a lesson was not saved -- {les1 => #{@les1.inspect}, les2 => #{@les2.inspect}, les3 => #{@les3.inspect}, les4 => #{@les4.inspect}, les5 => #{@les5.inspect}, les6 => #{@les6.inspect}, les7 => #{@les7.inspect}, les8 => #{@les8.inspect}, les9 => #{@les9.inspect},}"
    assert @les1.publish
    assert @les2.publish
    assert @les3.publish
    assert @les4.publish
    assert @les5.publish
    assert @les6.publish
    # MEDIA ELEMENTS
    @el1 = MediaElement.new :description => 'desc1', :title => 'titl1'
    @el1.user_id = 1
    @el1.sti_type = 'Video'
    @el1.duration = 10
    assert_obj_saved @el1
    @el2 = MediaElement.new :description => 'desc2', :title => 'titl2'
    @el2.user_id = 1
    @el2.sti_type = 'Video'
    @el2.duration = 10
    assert_obj_saved @el2
    @el3 = MediaElement.new :description => 'desc3', :title => 'titl3'
    @el3.user_id = 1
    @el3.sti_type = 'Audio'
    @el3.duration = 10
    assert_obj_saved @el3
    @el4 = MediaElement.new :description => 'desc4', :title => 'titl4'
    @el4.user_id = 1
    @el4.sti_type = 'Audio'
    @el4.duration = 10
    assert_obj_saved @el4
    @el5 = MediaElement.new :description => 'desc5', :title => 'titl5'
    @el5.user_id = 1
    @el5.sti_type = 'Image'
    assert_obj_saved @el5
    @el6 = MediaElement.new :description => 'desc6', :title => 'titl6'
    @el6.user_id = 1
    @el6.sti_type = 'Image'
    assert_obj_saved @el6
    @el7 = MediaElement.new :description => 'desc7', :title => 'titl7'
    @el7.user_id = 1
    @el7.sti_type = 'Image'
    assert_obj_saved @el7
    Lesson.record_timestamps = false
    MediaElement.record_timestamps = false
    @el1.is_public = true
    @el1.publication_date = '2012-01-01 10:00:00'
    @el1.updated_at = '2011-10-01 20:00:00'
    assert_obj_saved @el1
    @el2.is_public = true
    @el2.publication_date = '2012-01-01 10:00:00'
    @el2.updated_at = '2011-10-01 19:59:59'
    assert_obj_saved @el2
    @el3.is_public = true
    @el3.publication_date = '2012-01-01 10:00:00'
    @el3.updated_at = '2011-10-01 19:59:58'
    assert_obj_saved @el3
    @el4.updated_at = '2011-10-01 19:59:57'
    assert_obj_saved @el4
    @el5.is_public = true
    @el5.publication_date = '2012-01-01 10:00:00'
    @el5.updated_at = '2011-10-01 19:59:56'
    assert_obj_saved @el5
    @el6.updated_at = '2011-10-01 19:59:55'
    assert_obj_saved @el6
    @el7.is_public = true
    @el7.publication_date = '2012-01-01 10:00:00'
    @el7.updated_at = '2011-10-01 19:59:54'
    assert_obj_saved @el7
    date_now = '2011-01-01 20:00:00'.to_time
    Lesson.all.each do |l|
      l.updated_at = date_now
      assert_obj_saved l
      date_now -= 1
    end
    Lesson.record_timestamps = true
    MediaElement.record_timestamps = true
  end
  
  test 'suggested_lessons' do
    l = Lesson.find 2
    assert_equal 2, l.user_id
    assert_equal true, l.is_public
    assert_item_extractor [@les1.id, @les2.id, @les3.id, @les4.id], @user2.suggested_lessons(6)
    assert @user2.bookmark 'Lesson', @les2.id
    assert_item_extractor [@les1.id, @les3.id, @les4.id], @user2.suggested_lessons(6)
  end
  
  test 'suggested_media_elements' do
    assert @user2.bookmark 'MediaElement', @el3.id
    assert_item_extractor [2, @el1.id, @el2.id, @el5.id, @el7.id], @user2.suggested_media_elements(80)
  end
  
  test 'dashboard_emptied' do
    l = Lesson.find 2
    assert_equal 2, l.user_id
    assert_equal true, l.is_public
    assert !Lesson.dashboard_emptied?(2)
    assert @user2.bookmark 'Lesson', @les2.id
    assert Lesson.dashboard_emptied? 2
    assert MediaElement.dashboard_emptied? 2
    Bookmark.all.each do |b|
      b.destroy
    end
    assert !MediaElement.dashboard_emptied?(2)
  end
  
  test 'own_lessons' do
    assert Lesson.find(1).publish
    el = MediaElement.find(1)
    el.is_public = true
    el.publication_date = '2011-11-11 10:00:00'
    assert_obj_saved el
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    assert @user2.bookmark 'MediaElement', 1
    assert_item_extractor [1, 2, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20)[:content]
    # last page true
    resp = @user2.own_lessons(3, 2)
    assert_equal 1, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_lessons(1, 3)
    assert_equal 3, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_media_elements' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    assert_item_extractor [2, 3, 4, @el2.id, @el5.id], @user2.own_media_elements(1, 20)[:content]
    # last page true
    resp = @user2.own_media_elements(3, 2)
    assert_equal 1, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_media_elements(1, 4)
    assert_equal 4, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_media_elements_filter_video' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    assert_item_extractor [2, @el2.id], @user2.own_media_elements(1, 20, 'video')[:content]
    # last page true
    resp = @user2.own_media_elements(1, 2, 'video')
    assert_equal 2, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_media_elements(1, 1, 'video')
    assert_equal 1, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_media_elements_filter_audio' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    assert_item_extractor [3, 4], @user2.own_media_elements(1, 20, 'audio')[:content]
    # last page true
    resp = @user2.own_media_elements(1, 2, 'audio')
    assert_equal 2, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_media_elements(1, 1, 'audio')
    assert_equal 1, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_media_elements_filter_image' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    xxx = MediaElement.new
    xxx.user_id = 2
    xxx.title = 'tit1xxx'
    xxx.description = 'quef gsdsd dfs'
    xxx.sti_type = 'Image'
    assert_obj_saved xxx
    assert_item_extractor [xxx.id, @el5.id], @user2.own_media_elements(1, 20, 'image')[:content]
    # last page true
    resp = @user2.own_media_elements(1, 2, 'image')
    assert_equal 2, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_media_elements(1, 1, 'image')
    assert_equal 1, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_lessons_filter_private' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    les11 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les11.id)
    assert_item_extractor [les10.id, les11.id], @user2.own_lessons(1, 20, 'private')[:content]
    # last page true
    resp = @user2.own_lessons(1, 2, 'private')
    assert_equal 2, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_lessons(1, 1, 'private')
    assert_equal 1, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_lessons_filter_public' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    assert_item_extractor [1, 2, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20, 'public')[:content]
    # last page true
    resp = @user2.own_lessons(3, 2, 'public')
    assert_equal 1, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_lessons(1, 4, 'public')
    assert_equal 4, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_lessons_filter_linked' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    assert_item_extractor [1, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20, 'linked')[:content]
    # last page true
    resp = @user2.own_lessons(2, 2, 'linked')
    assert_equal 2, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_lessons(1, 3, 'linked')
    assert_equal 3, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_lessons_filter_only_mine' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    assert_item_extractor [2, les10.id], @user2.own_lessons(1, 20, 'only_mine')[:content]
    # last page true
    resp = @user2.own_lessons(1, 2, 'only_mine')
    assert_equal 2, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_lessons(1, 1, 'only_mine')
    assert_equal 1, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'own_lessons_filter_copied' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3)
    assert Lesson.exists?(les10.id)
    les11 = les10.copy(@user2.id)
    assert Lesson.exists?(les11.id)
    les12 = Lesson.find(1).copy(@user2.id)
    assert Lesson.exists?(les12.id)
    les13 = @les5.copy(@user2.id)
    assert Lesson.exists?(les13.id)
    assert_item_extractor [les11.id, les12.id, les13.id], @user2.own_lessons(1, 20, 'copied')[:content]
    # last page true
    resp = @user2.own_lessons(2, 2, 'copied')
    assert_equal 1, resp[:content].length
    assert resp[:last_page]
    # last page false
    resp = @user2.own_lessons(1, 2, 'copied')
    assert_equal 2, resp[:content].length
    assert !resp[:last_page]
  end
  
  test 'offset' do
    resp = @user1.own_lessons(1, 4)[:content]
    assert_equal 4, resp.length
    resptemp = @user1.own_lessons(2, 4)[:content]
    assert_equal 4, resptemp.length
    assert_extractor_intersection resp, resptemp
    resp += resptemp
    resptemp = @user1.own_lessons(3, 4)[:content]
    assert_equal 3, resptemp.length
    assert_extractor_intersection resp, resptemp
  end
  
  test 'notifications_methods' do
    Notification.all.each do |n|
      n.destroy
    end
    assert Notification.all.empty?
    (1...21).each do |i|
      assert Notification.send_to(1, "us1_n#{i}")
      assert Notification.send_to(2, "us2_n#{i}")
    end
    assert_equal 40, Notification.count
    us1_1 = Notification.find_by_message('us1_n1')
    us1_2 = Notification.find_by_message('us1_n2')
    us1_3 = Notification.find_by_message('us1_n3')
    us1_4 = Notification.find_by_message('us1_n4')
    us1_5 = Notification.find_by_message('us1_n5')
    us1_6 = Notification.find_by_message('us1_n6')
    us1_7 = Notification.find_by_message('us1_n7')
    us1_8 = Notification.find_by_message('us1_n8')
    us1_9 = Notification.find_by_message('us1_n9')
    us1_10 = Notification.find_by_message('us1_n10')
    us1_11 = Notification.find_by_message('us1_n11')
    us1_12 = Notification.find_by_message('us1_n12')
    us1_13 = Notification.find_by_message('us1_n13')
    us1_14 = Notification.find_by_message('us1_n14')
    us1_15 = Notification.find_by_message('us1_n15')
    us1_16 = Notification.find_by_message('us1_n16')
    us1_17 = Notification.find_by_message('us1_n17')
    us1_18 = Notification.find_by_message('us1_n18')
    us1_19 = Notification.find_by_message('us1_n19')
    us1_20 = Notification.find_by_message('us1_n20')
    us2_1 = Notification.find_by_message('us2_n1')
    us2_2 = Notification.find_by_message('us2_n2')
    us2_3 = Notification.find_by_message('us2_n3')
    us2_4 = Notification.find_by_message('us2_n4')
    us2_5 = Notification.find_by_message('us2_n5')
    us2_6 = Notification.find_by_message('us2_n6')
    us2_7 = Notification.find_by_message('us2_n7')
    us2_8 = Notification.find_by_message('us2_n8')
    us2_9 = Notification.find_by_message('us2_n9')
    us2_10 = Notification.find_by_message('us2_n10')
    us2_11 = Notification.find_by_message('us2_n11')
    us2_12 = Notification.find_by_message('us2_n12')
    us2_13 = Notification.find_by_message('us2_n13')
    us2_14 = Notification.find_by_message('us2_n14')
    us2_15 = Notification.find_by_message('us2_n15')
    us2_16 = Notification.find_by_message('us2_n16')
    us2_17 = Notification.find_by_message('us2_n17')
    us2_18 = Notification.find_by_message('us2_n18')
    us2_19 = Notification.find_by_message('us2_n19')
    us2_20 = Notification.find_by_message('us2_n20')
    Notification.record_timestamps = false
    us1_1.created_at = '2000-01-01 00:00:40'
    assert_obj_saved us1_1
    us1_2.created_at = '2000-01-01 00:00:39'
    assert_obj_saved us1_2
    us1_3.created_at = '2000-01-01 00:00:38'
    assert_obj_saved us1_3
    us1_4.created_at = '2000-01-01 00:00:37'
    assert_obj_saved us1_4
    us1_5.created_at = '2000-01-01 00:00:36'
    assert_obj_saved us1_5
    us1_6.created_at = '2000-01-01 00:00:35'
    assert_obj_saved us1_6
    us1_7.created_at = '2000-01-01 00:00:34'
    assert_obj_saved us1_7
    us1_8.created_at = '2000-01-01 00:00:33'
    assert_obj_saved us1_8
    us1_9.created_at = '2000-01-01 00:00:32'
    assert_obj_saved us1_9
    us1_10.created_at = '2000-01-01 00:00:31'
    assert_obj_saved us1_10
    us1_11.created_at = '2000-01-01 00:00:30'
    assert_obj_saved us1_11
    us1_12.created_at = '2000-01-01 00:00:29'
    assert_obj_saved us1_12
    us1_13.created_at = '2000-01-01 00:00:28'
    assert_obj_saved us1_13
    us1_14.created_at = '2000-01-01 00:00:27'
    assert_obj_saved us1_14
    us1_15.created_at = '2000-01-01 00:00:26'
    assert_obj_saved us1_15
    us1_16.created_at = '2000-01-01 00:00:25'
    assert_obj_saved us1_16
    us1_17.created_at = '2000-01-01 00:00:24'
    assert_obj_saved us1_17
    us1_18.created_at = '2000-01-01 00:00:23'
    assert_obj_saved us1_18
    us1_19.created_at = '2000-01-01 00:00:21'
    assert_obj_saved us1_19
    us1_20.created_at = '2000-01-01 00:00:20'
    assert_obj_saved us1_20
    us2_1.created_at = '2000-01-01 00:00:19'
    assert_obj_saved us2_1
    us2_2.created_at = '2000-01-01 00:00:18'
    assert_obj_saved us2_2
    us2_3.created_at = '2000-01-01 00:00:17'
    assert_obj_saved us2_3
    us2_4.created_at = '2000-01-01 00:00:16'
    assert_obj_saved us2_4
    us2_5.created_at = '2000-01-01 00:00:15'
    assert_obj_saved us2_5
    us2_6.created_at = '2000-01-01 00:00:14'
    assert_obj_saved us2_6
    us2_7.created_at = '2000-01-01 00:00:13'
    assert_obj_saved us2_7
    us2_8.created_at = '2000-01-01 00:00:12'
    assert_obj_saved us2_8
    us2_9.created_at = '2000-01-01 00:00:11'
    assert_obj_saved us2_9
    us2_10.created_at = '2000-01-01 00:00:10'
    assert_obj_saved us2_10
    us2_11.created_at = '2000-01-01 00:00:09'
    assert_obj_saved us2_11
    us2_12.created_at = '2000-01-01 00:00:08'
    assert_obj_saved us2_12
    us2_13.created_at = '2000-01-01 00:00:07'
    assert_obj_saved us2_13
    us2_14.created_at = '2000-01-01 00:00:06'
    assert_obj_saved us2_14
    us2_15.created_at = '2000-01-01 00:00:05'
    assert_obj_saved us2_15
    us2_16.created_at = '2000-01-01 00:00:04'
    assert_obj_saved us2_16
    us2_17.created_at = '2000-01-01 00:00:03'
    assert_obj_saved us2_17
    us2_18.created_at = '2000-01-01 00:00:02'
    assert_obj_saved us2_18
    us2_19.created_at = '2000-01-01 00:00:01'
    assert_obj_saved us2_19
    us2_20.created_at = '1999-12-31 23:59:59'
    assert_obj_saved us2_20
    Notification.record_timestamps = true
    Notification.where('id NOT IN (?)', [us2_20.id, us2_13.id, us2_8.id, us2_9.id, us1_1.id, us1_3.id, us1_15.id, us1_17.id, us1_18.id, us1_5.id]).each do |n|
      assert n.has_been_seen
    end
    assert_equal 4, Notification.number_not_seen(2)
    assert_equal 6, Notification.number_not_seen(1)
    assert us2_9.has_been_seen
    assert_equal 3, Notification.number_not_seen(2)
    assert_equal 6, Notification.number_not_seen(1)
    assert_extractor [us2_1.id, us2_2.id, us2_3.id, us2_4.id, us2_5.id], Notification.visible_block(2, 0, 5)
    assert_extractor [us1_1.id, us1_2.id, us1_3.id, us1_4.id, us1_5.id], Notification.visible_block(1, 0, 5)
  end
  
  test 'google_lessons_without_tags' do
    populate_tags
    assert_equal 34, Tag.count
    assert_equal 11, Lesson.count
    assert_equal 13, MediaElement.count
    assert_equal 168, Tagging.count
    x = MediaElement.order('id DESC')
    ids = []
    x.each do |i|
      ids << i.id
    end
    assert_extractor ids, MediaElement.order('updated_at DESC')
    x = Lesson.order('id DESC')
    ids = []
    x.each do |i|
      ids << i.id
    end
    assert_extractor ids, Lesson.order('updated_at DESC')
    # I start here, first case
    p1 = @user2.search_lessons('  ', 1, 5)
    p2 = @user2.search_lessons('', 2, 5, nil, 'bababah')
    assert_ordered_item_extractor [2, @les1.id, @les2.id, @les3.id, @les4.id], p1[:content]
    assert_equal false, p1[:last_page]
    assert_ordered_item_extractor [@les5.id, @les6.id], p2[:content]
    assert_equal true, p2[:last_page]
    # second case
    p1 = @user2.search_lessons('  ', 1, 5, nil, 'only_mine', nil)
    assert_ordered_item_extractor [2], p1[:content]
    assert_equal true, p1[:last_page]
    # third case
    p1 = @user2.search_lessons(nil, 1, 5, nil, 'not_mine')
    p2 = @user2.search_lessons('', 2, 5, 'beh', 'not_mine')
    assert_ordered_item_extractor [@les1.id, @les2.id, @les3.id, @les4.id, @les5.id], p1[:content]
    assert_equal false, p1[:last_page]
    assert_ordered_item_extractor [@les6.id], p2[:content]
    assert_equal true, p2[:last_page]
    # fourth case
    lll = Lesson.find(1)
    lll.is_public = true
    assert_obj_saved lll
    p1 = @user2.search_lessons('', 1, 5, nil, 'public')
    p2 = @user2.search_lessons('', 2, 5, nil, 'public', 'feafsa')
    assert_ordered_item_extractor [1, 2, @les1.id, @les2.id, @les3.id], p1[:content]
    assert_equal false, p1[:last_page]
    assert_ordered_item_extractor [@les4.id, @les5.id, @les6.id], p2[:content]
    assert_equal true, p2[:last_page]
    # fifth case
    p1 = @user2.search_lessons('', 1, 5, 'title', 'public', 1)
    assert_ordered_item_extractor [@les1.id, 1], p1[:content]
    assert_equal true, p1[:last_page]
    lll.is_public = false
    assert_obj_saved lll
    # sixth case
    old_number_users = User.count
    load_likes
    assert_equal (old_number_users + 9), User.count
    assert_equal 23, Like.count
    assert @les9.publish
    assert @les8.publish
    assert @les7.publish
    p1 = @user2.search_lessons(nil, 1, 5, 'likes', 'all_lessons', nil)
    p2 = @user2.search_lessons(nil, 2, 5, 'likes', 'all_lessons', nil)
    assert_ordered_item_extractor [@les1.id, @les8.id, @les3.id, @les6.id, @les7.id], p1[:content]
    assert_equal false, p1[:last_page]
    assert_ordered_item_extractor [@les4.id, @les5.id, @les9.id, @les2.id, 2], p2[:content]
    assert_equal true, p2[:last_page]
    # seventh case
    p1 = @user2.search_lessons(nil, 1, 5, 'likes', 'all_lessons', 3)
    assert_ordered_item_extractor [@les3.id, @les9.id, 2], p1[:content]
    assert_equal true, p1[:last_page]
  end
  
end
