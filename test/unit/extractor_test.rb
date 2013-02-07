# encoding: UTF-8

require 'test_helper'

class ExtractorTest < ActiveSupport::TestCase
  
  def load_likers
    @liker1 = User.confirmed.new(:password => 'em1@em.em', :password_confirmation => 'em1@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em1@em.em'
    end
    @liker1.policy_1 = '1'
    @liker1.policy_2 = '1'
    assert @liker1.save
    @liker2 = User.confirmed.new(:password => 'em2@em.em', :password_confirmation => 'em2@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em2@em.em'
    end
    @liker2.policy_1 = '1'
    @liker2.policy_2 = '1'
    assert @liker2.save
    @liker3 = User.confirmed.new(:password => 'em3@em.em', :password_confirmation => 'em3@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em3@em.em'
    end
    @liker3.policy_1 = '1'
    @liker3.policy_2 = '1'
    assert @liker3.save
    @liker4 = User.confirmed.new(:password => 'em4@em.em', :password_confirmation => 'em4@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em4@em.em'
    end
    @liker4.policy_1 = '1'
    @liker4.policy_2 = '1'
    assert @liker4.save
    @liker5 = User.confirmed.new(:password => 'em5@em.em', :password_confirmation => 'em5@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em5@em.em'
    end
    @liker5.policy_1 = '1'
    @liker5.policy_2 = '1'
    assert @liker5.save
    @liker6 = User.confirmed.new(:password => 'em6@em.em', :password_confirmation => 'em6@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em6@em.em'
    end
    @liker6.policy_1 = '1'
    @liker6.policy_2 = '1'
    assert @liker6.save
    @liker7 = User.confirmed.new(:password => 'em7@em.em', :password_confirmation => 'em7@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em7@em.em'
    end
    @liker7.policy_1 = '1'
    @liker7.policy_2 = '1'
    assert @liker7.save
    @liker8 = User.confirmed.new(:password => 'em8@em.em', :password_confirmation => 'em8@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em8@em.em'
    end
    @liker8.policy_1 = '1'
    @liker8.policy_2 = '1'
    assert @liker8.save
    @liker9 = User.confirmed.new(:password => 'em9@em.em', :password_confirmation => 'em9@em.em', :name => 'dgdsg', :surname => 'sdgds', :school => 'adgadg', :school_level_id => 1, :location_id => 1, :subject_ids => [1]) do |user|
      user.email = 'em9@em.em'
    end
    @liker9.policy_1 = '1'
    @liker9.policy_2 = '1'
    assert @liker9.save
  end
  
  def load_likes
    load_likers
    Like.all.each do |l|
      l.destroy
    end
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
  
  def setup
    @user1 = User.find 1
    @user1.name = 'a_name'
    @user1.surname = 'a_surname'
    @user1.school = 'a_school'
    assert_obj_saved @user1
    us_sub_1_2 = UsersSubject.new
    us_sub_1_2.user_id = 1
    us_sub_1_2.subject_id = 2
    assert_obj_saved us_sub_1_2
    us_sub_1_4 = UsersSubject.new
    us_sub_1_4.user_id = 1
    us_sub_1_4.subject_id = 4
    assert_obj_saved us_sub_1_4
    us_sub_1_5 = UsersSubject.new
    us_sub_1_5.user_id = 1
    us_sub_1_5.subject_id = 5
    assert_obj_saved us_sub_1_5
    us_sub_1_6 = UsersSubject.new
    us_sub_1_6.user_id = 1
    us_sub_1_6.subject_id = 6
    assert_obj_saved us_sub_1_6
    @user2 = User.find 2
    @user2.name = 'a_name'
    @user2.surname = 'a_surname'
    @user2.school = 'a_school'
    assert_obj_saved @user2
    us_sub_2_2 = UsersSubject.new
    us_sub_2_2.user_id = 2
    us_sub_2_2.subject_id = 2
    assert_obj_saved us_sub_2_2
    us_sub_2_3 = UsersSubject.new
    us_sub_2_3.user_id = 2
    us_sub_2_3.subject_id = 3
    assert_obj_saved us_sub_2_3
    us_sub_2_4 = UsersSubject.new
    us_sub_2_4.user_id = 2
    us_sub_2_4.subject_id = 4
    assert_obj_saved us_sub_2_4
    @user1 = User.find 1
    @user2 = User.find 2
    Tagging.all.each do |t|
      ActiveRecord::Base.connection.execute "DELETE FROM taggings WHERE id = #{t.id}"
    end
    Tag.all.each do |t|
      t.destroy
    end
    tag_map = {
      0 => "cane, sole, togatto, cincillà, walter nudo, luna, di escrementi di usignolo",
      1 => "walter nudo, luna, di escrementi di usignolo, disabili, torriere architettoniche, mare, petrolio",
      2 => "torriere architettoniche, mare, petrolio, sostenibilità, di immondizia, tonquinamento atmosferico, tonquinamento",
      3 => "tonquinamento, pollution, tom cruise, cammello, cammelli, acqua, acquario",
      4 => "cammelli, acqua, acquario, acquatico, 個名, 拿大即, 河",
      5 => "個名, 拿大即, 河, 條聖, 係英國, 拿, 住羅倫",
      6 => "係英國, 拿, 住羅倫, 加, 大湖, 咗做, 個",
      7 => "大湖, 咗做, 個, 條聖法話, cane, sole, togatto",
      8 => "togatto, luna, torriere architettoniche, sostenibilità, tonquinamento, cammello, acquario",
      9 => "di escrementi di usignolo, tonquinamento atmosferico, acquario, 拿, walter nudo, mare, tonquinamento"
    }
    me1 = MediaElement.find 1
    me1.tags = tag_map[0]
    assert_obj_saved me1
    me2 = MediaElement.find 2
    me2.tags = tag_map[1]
    assert_obj_saved me2
    me3 = MediaElement.find 3
    me3.tags = tag_map[2]
    assert_obj_saved me3
    me4 = MediaElement.find 4
    me4.tags = tag_map[3]
    assert_obj_saved me4
    me5 = MediaElement.find 5
    me5.tags = tag_map[4]
    assert_obj_saved me5
    me6 = MediaElement.find 6
    me6.tags = tag_map[5]
    assert_obj_saved me6
    @el1 = MediaElement.new :description => 'desc1', :title => 'titl1'
    @el1.user_id = 1
    @el1.sti_type = 'Video'
    @el1.tags = tag_map[8]
    @el1.media = {:mp4 => Rails.root.join("test/samples/one.mp4").to_s, :webm => Rails.root.join("test/samples/one.webm").to_s, :filename => "video_test"}
    assert_obj_saved @el1
    @el2 = MediaElement.new :description => 'desc2', :title => 'titl2'
    @el2.user_id = 1
    @el2.sti_type = 'Video'
    @el2.tags = tag_map[9]
    @el2.media = {:mp4 => Rails.root.join("test/samples/one.mp4").to_s, :webm => Rails.root.join("test/samples/one.webm").to_s, :filename => "video_test"}
    assert_obj_saved @el2
    @el3 = MediaElement.new :description => 'desc3', :title => 'titl3'
    @el3.user_id = 1
    @el3.sti_type = 'Audio'
    @el3.tags = tag_map[0]
    @el3.media = {:mp3 => Rails.root.join("test/samples/one.mp3").to_s, :ogg => Rails.root.join("test/samples/one.ogg").to_s, :filename => "audio_test"}
    assert_obj_saved @el3
    @el4 = MediaElement.new :description => 'desc4', :title => 'titl4'
    @el4.user_id = 1
    @el4.sti_type = 'Audio'
    @el4.tags = tag_map[6]
    @el4.media = {:mp3 => Rails.root.join("test/samples/one.mp3").to_s, :ogg => Rails.root.join("test/samples/one.ogg").to_s, :filename => "audio_test"}
    assert_obj_saved @el4
    @el5 = MediaElement.new :description => 'desc5', :title => 'titl5'
    @el5.user_id = 1
    @el5.sti_type = 'Image'
    @el5.tags = tag_map[1]
    @el5.media = File.open(Rails.root.join("test/samples/one.jpg"))
    assert_obj_saved @el5
    @el6 = MediaElement.new :description => 'desc6', :title => 'titl6'
    @el6.user_id = 1
    @el6.sti_type = 'Image'
    @el6.tags = tag_map[7]
    @el6.media = File.open(Rails.root.join("test/samples/one.jpg"))
    assert_obj_saved @el6
    @el7 = MediaElement.new :description => 'desc7', :title => 'titl7'
    @el7.user_id = 1
    @el7.sti_type = 'Image'
    @el7.tags = tag_map[2]
    @el7.media = File.open(Rails.root.join("test/samples/one.jpg"))
    assert_obj_saved @el7
    le1 = Lesson.find 1
    le1.tags = tag_map[3]
    assert_obj_saved le1
    le2 = Lesson.find 2
    le2.tags = tag_map[4]
    assert_obj_saved le2
    @les1 = @user1.create_lesson('title1', 'desc1', 1, tag_map[8])
    @les2 = @user1.create_lesson('title2', 'desc2', 2, tag_map[9])
    @les3 = @user1.create_lesson('title3', 'desc3', 3, tag_map[0])
    @les4 = @user1.create_lesson('title4', 'desc4', 4, tag_map[1])
    @les5 = @user1.create_lesson('title5', 'desc5', 5, tag_map[2])
    @les6 = @user1.create_lesson('title6', 'desc6', 6, tag_map[3])
    @les7 = @user1.create_lesson('title7', 'desc7', 1, tag_map[5])
    @les8 = @user1.create_lesson('title8', 'desc8', 2, tag_map[6])
    @les9 = @user1.create_lesson('title9', 'desc9', 3, tag_map[7])
    assert_equal 11, Lesson.count, "Error, a lesson was not saved -- {les1 => #{@les1.inspect}, les2 => #{@les2.inspect}, les3 => #{@les3.inspect}, les4 => #{@les4.inspect}, les5 => #{@les5.inspect}, les6 => #{@les6.inspect}, les7 => #{@les7.inspect}, les8 => #{@les8.inspect}, les9 => #{@les9.inspect},}"
    assert @les1.publish
    assert @les2.publish
    assert @les3.publish
    assert @les4.publish
    assert @les5.publish
    assert @les6.publish
    # I SET UPDATED AT
    MediaElement.where(:id => 1).update_all(:updated_at => '2012-01-01 20:00:00')
    MediaElement.where(:id => 2).update_all(:updated_at => '2012-01-01 19:59:59')
    MediaElement.where(:id => 3).update_all(:updated_at => '2012-01-01 19:59:58')
    MediaElement.where(:id => 4).update_all(:updated_at => '2012-01-01 19:59:57')
    MediaElement.where(:id => 5).update_all(:updated_at => '2012-01-01 19:59:56')
    MediaElement.where(:id => 6).update_all(:updated_at => '2012-01-01 19:59:55')
    MediaElement.where(:id => @el1.id).update_all(:updated_at => '2011-10-01 20:00:00', :is_public => true, :publication_date => '2012-01-01 10:00:00')
    MediaElement.where(:id => @el2.id).update_all(:updated_at => '2011-10-01 19:59:59', :is_public => true, :publication_date => '2012-01-01 10:00:00')
    MediaElement.where(:id => @el3.id).update_all(:updated_at => '2011-10-01 19:59:58', :is_public => true, :publication_date => '2012-01-01 10:00:00')
    MediaElement.where(:id => @el4.id).update_all(:updated_at => '2011-10-01 19:59:57')
    MediaElement.where(:id => @el5.id).update_all(:updated_at => '2011-10-01 19:59:56', :is_public => true, :publication_date => '2012-01-01 10:00:00')
    MediaElement.where(:id => @el6.id).update_all(:updated_at => '2011-10-01 19:59:55')
    MediaElement.where(:id => @el7.id).update_all(:updated_at => '2011-10-01 19:59:54', :is_public => true, :publication_date => '2012-01-01 10:00:00')
    date_now = '2011-01-01 20:00:00'.to_time
    Lesson.all.each do |l|
      Lesson.where(:id => l.id).update_all(:updated_at => date_now)
      date_now -= 1
    end
  end
  
  # FIXME da qui...
  
  test 'lesson_multiplicity' do
    Lesson.where('id != 1').delete_all
    assert Lesson.find(1).publish
    Bookmark.delete_all
    assert_equal 1, Lesson.count
    assert_equal 0, Bookmark.count
    load_likers
    assert @liker1.bookmark 'Lesson', 1
    assert @liker2.bookmark 'Lesson', 1
    assert @liker3.bookmark 'Lesson', 1
    assert @liker4.bookmark 'Lesson', 1
    assert @liker5.bookmark 'Lesson', 1
    assert @liker6.bookmark 'Lesson', 1
    assert_equal 6, Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => 1).count
  end
  
  test 'media_element_multiplicity' do
    
  end
  
  # FIXME ...a qui!
  
  test 'ordered_own_items' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    # order lessons
    Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => 1, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:03')
    Lesson.where(:id => 2).update_all(:updated_at => '2012-01-01 10:00:04')
    Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => @les2.id, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:05')
    Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => @les5.id, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:01')
    Bookmark.where(:bookmarkable_type => 'Lesson', :bookmarkable_id => @les6.id, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:02')
    # order media elements
    Bookmark.where(:bookmarkable_type => 'MediaElement', :bookmarkable_id => 2, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:01')
    MediaElement.where(:id => 3).update_all(:updated_at => '2012-01-01 10:00:03')
    Bookmark.where(:bookmarkable_type => 'MediaElement', :bookmarkable_id => 4, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:05')
    Bookmark.where(:bookmarkable_type => 'MediaElement', :bookmarkable_id => @el2.id, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:04')
    Bookmark.where(:bookmarkable_type => 'MediaElement', :bookmarkable_id => @el5.id, :user_id => @user2.id).update_all(:created_at => '2012-01-01 10:00:02')
    assert_ordered_item_extractor [@les2.id, 2, 1, @les6.id, @les5.id], @user2.own_lessons(1, 20)[:records]
    assert_ordered_item_extractor [4, @el2.id, 3, @el5.id, 2], @user2.own_media_elements(1, 20)[:records]
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
    assert_item_extractor [1, 2, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20)[:records]
    # last page true
    resp = @user2.own_lessons(3, 2)
    assert_equal 1, resp[:records].length
    assert_equal 3, resp[:pages_amount]
    # last page false
    resp = @user2.own_lessons(1, 3)
    assert_equal 3, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'own_media_elements' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    assert_item_extractor [2, 3, 4, @el2.id, @el5.id], @user2.own_media_elements(1, 20)[:records]
    # last page true
    resp = @user2.own_media_elements(3, 2)
    assert_equal 1, resp[:records].length
    assert_equal 3, resp[:pages_amount]
    # last page false
    resp = @user2.own_media_elements(1, 4)
    assert_equal 4, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'own_media_elements_filter_video' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    assert_item_extractor [2, @el2.id], @user2.own_media_elements(1, 20, 'video')[:records]
    # last page true
    resp = @user2.own_media_elements(1, 2, 'video')
    assert_equal 2, resp[:records].length
    assert_equal 1, resp[:pages_amount]
    # last page false
    resp = @user2.own_media_elements(1, 1, 'video')
    assert_equal 1, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'own_media_elements_filter_audio' do
    assert @user2.bookmark 'MediaElement', 2
    assert @user2.bookmark 'MediaElement', @el2.id
    assert @user2.bookmark 'MediaElement', @el5.id
    assert_item_extractor [3, 4], @user2.own_media_elements(1, 20, 'audio')[:records]
    # last page true
    resp = @user2.own_media_elements(1, 2, 'audio')
    assert_equal 2, resp[:records].length
    assert_equal 1, resp[:pages_amount]
    # last page false
    resp = @user2.own_media_elements(1, 1, 'audio')
    assert_equal 1, resp[:records].length
    assert_equal 2, resp[:pages_amount]
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
    xxx.tags = 'tag1, tag2, tag3, tag4'
    xxx.media = File.open(Rails.root.join("test/samples/one.jpg"))
    assert_obj_saved xxx
    assert_item_extractor [xxx.id, @el5.id], @user2.own_media_elements(1, 20, 'image')[:records]
    # last page true
    resp = @user2.own_media_elements(1, 2, 'image')
    assert_equal 2, resp[:records].length
    assert_equal 1, resp[:pages_amount]
    # last page false
    resp = @user2.own_media_elements(1, 1, 'image')
    assert_equal 1, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'own_lessons_filter_private' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3, 'pippo, pluto, paperino, topolino')
    assert Lesson.exists?(les10.id)
    les11 = @user2.create_lesson('title10', 'desc10', 3, 'pippo, pluto, paperino, topolino')
    assert Lesson.exists?(les11.id)
    assert_item_extractor [les10.id, les11.id], @user2.own_lessons(1, 20, 'private')[:records]
    # last page true
    resp = @user2.own_lessons(1, 2, 'private')
    assert_equal 2, resp[:records].length
    assert_equal 1, resp[:pages_amount]
    # last page false
    resp = @user2.own_lessons(1, 1, 'private')
    assert_equal 1, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'own_lessons_filter_public' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3, 'pippo, pluto, paperino, topolino')
    assert Lesson.exists?(les10.id)
    assert_item_extractor [1, 2, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20, 'public')[:records]
    # last page true
    resp = @user2.own_lessons(3, 2, 'public')
    assert_equal 1, resp[:records].length
    assert_equal 3, resp[:pages_amount]
    # last page false
    resp = @user2.own_lessons(1, 4, 'public')
    assert_equal 4, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'own_lessons_filter_linked' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3, 'pippo, pluto, paperino, topolino')
    assert Lesson.exists?(les10.id)
    assert_item_extractor [1, @les2.id, @les5.id, @les6.id], @user2.own_lessons(1, 20, 'linked')[:records]
    # last page true
    resp = @user2.own_lessons(2, 2, 'linked')
    assert_equal 2, resp[:records].length
    assert_equal 2, resp[:pages_amount]
    # last page false
    resp = @user2.own_lessons(1, 1, 'linked')
    assert_equal 1, resp[:records].length
    assert_equal 4, resp[:pages_amount]
  end
  
  test 'own_lessons_filter_only_mine' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3, 'pippo, pluto, paperino, topolino')
    assert Lesson.exists?(les10.id)
    assert_item_extractor [2, les10.id], @user2.own_lessons(1, 20, 'only_mine')[:records]
    # last page true
    resp = @user2.own_lessons(1, 2, 'only_mine')
    assert_equal 2, resp[:records].length
    assert_equal 1, resp[:pages_amount]
    # last page false
    resp = @user2.own_lessons(1, 1, 'only_mine')
    assert_equal 1, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'own_lessons_filter_copied' do
    assert Lesson.find(1).publish
    assert @user2.bookmark 'Lesson', @les2.id
    assert @user2.bookmark 'Lesson', @les5.id
    assert @user2.bookmark 'Lesson', @les6.id
    assert @user2.bookmark 'Lesson', 1
    les10 = @user2.create_lesson('title10', 'desc10', 3, 'pippo, pluto, paperino, topolino')
    assert Lesson.exists?(les10.id)
    les11 = les10.copy(@user2.id)
    assert Lesson.exists?(les11.id)
    les12 = Lesson.find(1).copy(@user2.id)
    assert Lesson.exists?(les12.id)
    les13 = @les5.copy(@user2.id)
    assert Lesson.exists?(les13.id)
    assert_item_extractor [les11.id, les12.id, les13.id], @user2.own_lessons(1, 20, 'copied')[:records]
    # last page true
    resp = @user2.own_lessons(2, 2, 'copied')
    assert_equal 1, resp[:records].length
    assert_equal 2, resp[:pages_amount]
    # last page false
    resp = @user2.own_lessons(1, 2, 'copied')
    assert_equal 2, resp[:records].length
    assert_equal 2, resp[:pages_amount]
  end
  
  test 'offset' do
    resp = @user1.own_lessons(1, 4)[:records]
    assert_equal 4, resp.length
    resptemp = @user1.own_lessons(2, 4)[:records]
    assert_equal 4, resptemp.length
    assert_extractor_intersection resp, resptemp
    resp += resptemp
    resptemp = @user1.own_lessons(3, 4)[:records]
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
    assert_equal 4, User.find(2).number_notifications_not_seen
    assert_equal 6, User.find(1).number_notifications_not_seen
    assert us2_9.has_been_seen
    assert_equal 3, User.find(2).number_notifications_not_seen
    assert_equal 6, User.find(1).number_notifications_not_seen
    assert_extractor [us2_1.id, us2_2.id, us2_3.id, us2_4.id, us2_5.id], User.find(2).notifications_visible_block(0, 5)
    assert_extractor [us1_1.id, us1_2.id, us1_3.id, us1_4.id, us1_5.id], User.find(1).notifications_visible_block(0, 5)
  end
  
  test 'google_lessons_without_tags' do
    assert_equal 11, Lesson.count
    assert_equal 13, MediaElement.count
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
    assert_ordered_item_extractor [2, @les1.id, @les2.id, @les3.id, @les4.id], p1[:records]
    assert_equal 7, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@les5.id, @les6.id], p2[:records]
    assert_equal 7, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # second case
    p1 = @user2.search_lessons('  ', 1, 5, nil, 'only_mine', nil)
    assert_ordered_item_extractor [2], p1[:records]
    assert_equal 1, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # third case
    p1 = @user2.search_lessons(nil, 1, 5, nil, 'not_mine')
    p2 = @user2.search_lessons('', 2, 5, 'beh', 'not_mine')
    assert_ordered_item_extractor [@les1.id, @les2.id, @les3.id, @les4.id, @les5.id], p1[:records]
    assert_equal 6, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@les6.id], p2[:records]
    assert_equal 6, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # fourth case
    lll = Lesson.find(1)
    lll.is_public = true
    assert_obj_saved lll
    p1 = @user2.search_lessons('', 1, 5, nil, 'public')
    p2 = @user2.search_lessons('', 2, 5, nil, 'public', 'feafsa')
    assert_ordered_item_extractor [1, 2, @les1.id, @les2.id, @les3.id], p1[:records]
    assert_equal 8, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@les4.id, @les5.id, @les6.id], p2[:records]
    assert_equal 8, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # fifth case
    p1 = @user2.search_lessons('', 1, 5, 'title', 'public', 1)
    assert_ordered_item_extractor [@les1.id, 1], p1[:records]
    assert_equal 2, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
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
    assert_ordered_item_extractor [@les1.id, @les8.id, @les3.id, @les6.id, @les7.id], p1[:records]
    assert_equal 10, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@les4.id, @les5.id, @les9.id, @les2.id, 2], p2[:records]
    assert_equal 10, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # seventh case
    p1 = @user2.search_lessons(nil, 1, 5, 'likes', 'all_lessons', 3)
    assert_ordered_item_extractor [@les3.id, @les9.id, 2], p1[:records]
    assert_equal 3, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
  end
  
  test 'populate_tags' do
    assert_equal 34, Tag.count
    assert_equal 11, Lesson.count
    assert_equal 13, MediaElement.count
    assert_equal 168, Tagging.count
    assert_tags MediaElement.find(1), ['cane', 'sole', 'togatto', 'cincillà', 'walter nudo', 'luna', 'di escrementi di usignolo']
    assert_tags MediaElement.find(2), ['walter nudo', 'luna', 'di escrementi di usignolo', 'disabili', 'torriere architettoniche', 'mare', 'petrolio']
    assert_tags MediaElement.find(3), ['torriere architettoniche', 'mare', 'petrolio', 'sostenibilità', 'di immondizia', 'tonquinamento atmosferico', 'tonquinamento']
    assert_tags MediaElement.find(4), ['tonquinamento', 'pollution', 'tom cruise', 'cammello', 'cammelli', 'acqua', 'acquario']
    assert_tags MediaElement.find(5), ['cammelli', 'acqua', 'acquario', 'acquatico', '個名', '拿大即', '河']
    assert_tags MediaElement.find(6), ['個名', '拿大即', '河', '條聖', '係英國', '拿', '住羅倫']
    assert_tags @el1, ['togatto', 'luna', 'torriere architettoniche', 'sostenibilità', 'tonquinamento', 'cammello', 'acquario']
    assert_tags @el2, ['di escrementi di usignolo', 'tonquinamento atmosferico', 'acquario', '拿', 'walter nudo', 'mare', 'tonquinamento']
    assert_tags @el3, ['cane', 'sole', 'togatto', 'cincillà', 'walter nudo', 'luna', 'di escrementi di usignolo']
    assert_tags @el4, ['係英國', '拿', '住羅倫', '加', '大湖', '咗做', '個']
    assert_tags @el5, ['walter nudo', 'luna', 'di escrementi di usignolo', 'disabili', 'torriere architettoniche', 'mare', 'petrolio']
    assert_tags @el6, ['大湖', '咗做', '個', '條聖法話', 'cane', 'sole', 'togatto']
    assert_tags @el7, ['torriere architettoniche', 'mare', 'petrolio', 'sostenibilità', 'di immondizia', 'tonquinamento atmosferico', 'tonquinamento']
    assert_tags Lesson.find(1), ['tonquinamento', 'pollution', 'tom cruise', 'cammello', 'cammelli', 'acqua', 'acquario']
    assert_tags Lesson.find(2), ['cammelli', 'acqua', 'acquario', 'acquatico', '個名', '拿大即', '河']
    assert_tags @les1, ['togatto', 'luna', 'torriere architettoniche', 'sostenibilità', 'tonquinamento', 'cammello', 'acquario']
    assert_tags @les2, ['di escrementi di usignolo', 'tonquinamento atmosferico', 'acquario', '拿', 'walter nudo', 'mare', 'tonquinamento']
    assert_tags @les3, ['cane', 'sole', 'togatto', 'cincillà', 'walter nudo', 'luna', 'di escrementi di usignolo']
    assert_tags @les4, ['walter nudo', 'luna', 'di escrementi di usignolo', 'disabili', 'torriere architettoniche', 'mare', 'petrolio']
    assert_tags @les5, ['torriere architettoniche', 'mare', 'petrolio', 'sostenibilità', 'di immondizia', 'tonquinamento atmosferico', 'tonquinamento']
    assert_tags @les6, ['tonquinamento', 'pollution', 'tom cruise', 'cammello', 'cammelli', 'acqua', 'acquario']
    assert_tags @les7, ['個名', '拿大即', '河', '條聖', '係英國', '拿', '住羅倫']
    assert_tags @les8, ['係英國', '拿', '住羅倫', '加', '大湖', '咗做', '個']
    assert_tags @les9, ['大湖', '咗做', '個', '條聖法話', 'cane', 'sole', 'togatto']
  end
  
  test 'google_lessons_with_tags' do
    # preliminarly, I try looking for a specific tag
    luna = Tag.find_by_word 'luna'
    p1 = @user2.search_lessons(luna.id, 1, 5)
    assert_ordered_item_extractor [@les1.id, @les3.id, @les4.id], p1[:records]
    assert !p1.has_key?(:tags)
    assert_equal 3, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # it works only with integer
    p1 = @user2.search_lessons(luna.id.to_f, 1, 5)
    assert p1[:records].empty?
    assert p1[:tags].empty?
    assert_equal 0, p1[:records_amount]
    assert_equal 0, p1[:pages_amount]
    # I start here, first case - no match
    p1 = @user2.search_lessons('ciao', 1, 5, nil, nil, nil)
    assert p1[:records].empty?
    assert p1[:tags].empty?
    assert_equal 0, p1[:records_amount]
    assert_equal 0, p1[:pages_amount]
    # second case - it matches three tags
    p1 = @user2.search_lessons('di', 1, 5, nil, nil, nil)
    assert_ordered_item_extractor [@les2.id, @les3.id, @les4.id, @les5.id], p1[:records]
    tag_ids = []
    Tag.where(:word => ['di escrementi di usignolo', 'disabili', 'di immondizia']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 4, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # third case - it matches more tags - @les9 is not found because private
    assert Lesson.find(1).publish
    p1 = @user2.search_lessons('to', 1, 5, nil, nil, nil)
    p2 = @user2.search_lessons('to', 2, 5, nil, nil, nil)
    assert_ordered_item_extractor [1, @les1.id, @les2.id, @les3.id, @les4.id], p1[:records]
    tag_ids = []
    Tag.where(:word => ['togatto', 'torriere architettoniche', 'tonquinamento', 'tonquinamento atmosferico', 'tom cruise']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 7, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@les5.id, @les6.id], p2[:records]
    assert_extractor tag_ids, p2[:tags]
    assert_equal 7, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # fourth case - filters and orders on the last search
    lees2 = Lesson.find 2
    lees2.tags = '個名, Tonio de curtis, acquazzone, zzzzaggiunta a caso'
    assert_obj_saved lees2
    assert_equal 37, Tag.count
    assert_equal 165, Tagging.count
    p1 = @user2.search_lessons('to', 1, 5, nil, 'only_mine', nil)
    assert_ordered_item_extractor [2], p1[:records]
    tag_ids << Tag.find_by_word('tonio de curtis').id
    assert_extractor tag_ids, p1[:tags]
    assert_equal 1, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # fifth case - words with similar beginning - I sort for likes and title
    load_likes
    assert Lesson.find(1).unpublish
    p1 = @user2.search_lessons('acqua', 1, 5, 'likes', 'public', nil)
    assert_ordered_item_extractor [@les1.id, @les6.id, @les2.id, 2], p1[:records]
    tag_ids = []
    Tag.where(:word => ['acqua', 'acquatico', 'acquario', 'acquazzone']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 4, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # sixth case
    assert Lesson.find(1).publish
    p1 = @user2.search_lessons('acqua', 1, 5, 'likes', 'not_mine', nil)
    assert_ordered_item_extractor [@les1.id, @les6.id, @les2.id, 1], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 4, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # seventh case
    p1 = @user2.search_lessons('acqua', 1, 5, 'title', 'not_mine', nil)
    assert_ordered_item_extractor [@les1.id, @les2.id, @les6.id, 1], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 4, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # eight case
    p1 = @user2.search_lessons('acqua', 1, 5, 'title', 'not_mine', 1)
    assert_ordered_item_extractor [@les1.id, 1], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 2, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # ninth case
    p1 = @user2.search_lessons('walter ', 1, 5, nil, nil, nil)
    assert_ordered_item_extractor [@les2.id, @les3.id, @les4.id], p1[:records]
    assert_extractor [Tag.find_by_word('walter nudo').id], p1[:tags]
    assert_equal 3, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # check that it does not work for middle words
    xx = @user2.search_lessons('nudo', 1, 5)
    assert xx[:records].empty?
    assert xx[:tags].empty?
    assert_equal 0, xx[:records_amount]
    assert_equal 0, xx[:pages_amount]
    # cases in chinese
    [@les7, @les8, @les9].each do |llll|
      assert Lesson.find(llll.id).publish
    end
    p1 = @user2.search_lessons('個', 1, 5, 'title', nil, nil)
    assert_ordered_item_extractor [2, @les7.id, @les8.id, @les9.id], p1[:records]
    tag_ids = []
    Tag.where(:word => ['個名', '個']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 4, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    p1 = @user2.search_lessons('條聖', 1, 5, 'title', nil, nil)
    assert_ordered_item_extractor [@les7.id, @les9.id], p1[:records]
    tag_ids = []
    Tag.where(:word => ['條聖法話', '條聖']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 2, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # I check that I find tags but not associated lessons
    assert @user2.search_lessons('cammelli', 1, 5)[:records].any?
    assert @les6.unpublish
    cammelli = Tag.find_by_word 'cammelli'
    cammelli.taggings.where(:taggable_type => 'Lesson').each do |t|
      t.destroy if t.taggable_id != @les6.id
    end
    assert Tagging.where(:taggable_type => 'Lesson', :tag_id => cammelli.id).any?
    xxx = @user2.search_lessons('cammelli', 1, 5)
    assert xxx[:records].empty?
    assert_extractor [cammelli.id], xxx[:tags]
  end
  
  test 'google_media_elements_without_tags' do
    # I start here, first case
    p1 = @user2.search_media_elements('  ', 1, 5)
    p2 = @user2.search_media_elements('', 2, 5, nil, 'bababah')
    assert_ordered_item_extractor [2, 3, 4, 6, @el1.id], p1[:records]
    assert_equal 9, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@el2.id, @el3.id, @el5.id, @el7.id], p2[:records]
    assert_equal 9, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # second case, filter image
    p1 = @user2.search_media_elements('', 1, 5, 'updated_at', 'image')
    assert_ordered_item_extractor [6, @el5.id, @el7.id], p1[:records]
    assert_equal 3, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # third case, filter audio - order by title
    p1 = @user2.search_media_elements('', 1, 5, 'title', 'audio')
    assert_ordered_item_extractor [4, @el3.id, 3], p1[:records]
    assert_equal 3, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # fourth case, filter video -- order by title
    p1 = @user2.search_media_elements('', 1, 5, 'title', 'video')
    assert_ordered_item_extractor [@el1.id, @el2.id, 2], p1[:records]
    assert_equal 3, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
  end
  
  test 'google_media_elements_with_tags' do
    # preliminarly, I try looking for a specific tag
    luna = Tag.find_by_word 'luna'
    p1 = @user2.search_media_elements(luna.id, 1, 5)
    assert_ordered_item_extractor [2, @el1.id, @el3.id, @el5.id], p1[:records]
    assert !p1.has_key?(:tags)
    assert_equal 4, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # it works only with integer
    p1 = @user2.search_media_elements(luna.id.to_f, 1, 5)
    assert p1[:records].empty?
    assert assert p1[:tags].empty?
    assert_equal 0, p1[:records_amount]
    assert_equal 0, p1[:pages_amount]
    # I start here, first case - no match
    p1 = @user2.search_media_elements('ciao', 1, 5, nil, nil)
    assert p1[:records].empty?
    assert p1[:tags].empty?
    assert_equal 0, p1[:records_amount]
    assert_equal 0, p1[:pages_amount]
    # second case - it matches three tags
    p1 = @user2.search_media_elements('di', 1, 5, nil, nil)
    p2 = @user2.search_media_elements('di', 2, 5, nil, nil)
    assert_ordered_item_extractor [2, 3, @el2.id, @el3.id, @el5.id], p1[:records]
    tag_ids = []
    Tag.where(:word => ['di escrementi di usignolo', 'disabili', 'di immondizia']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 6, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@el7.id], p2[:records]
    assert_extractor tag_ids, p2[:tags]
    assert_equal 6, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # third case - it matches more tags
    p1 = @user2.search_media_elements('to', 1, 5, 'title', nil)
    p2 = @user2.search_media_elements('to', 2, 5, 'title', nil)
    assert_ordered_item_extractor [4, @el1.id, @el2.id, @el3.id, @el5.id], p1[:records]
    tag_ids = []
    Tag.where(:word => ['togatto', 'torriere architettoniche', 'tonquinamento', 'tonquinamento atmosferico', 'tom cruise']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 8, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [@el7.id, 2, 3], p2[:records]
    assert_extractor tag_ids, p2[:tags]
    assert_equal 8, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # fourth case - chinese characters, and filters
    p1 = @user2.search_media_elements('加', 1, 5)
    assert p1[:records].empty?
    tag_ids = []
    Tag.where(:word => ['加']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 0, p1[:records_amount]
    assert_equal 0, p1[:pages_amount]
    @el4.is_public = true
    @el4.publication_date = '2011-01-01 10:00:00'
    assert_obj_saved @el4
    p1 = @user2.search_media_elements('加', 1, 5)
    assert_ordered_item_extractor [@el4.id], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 1, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    p1 = @user2.search_media_elements('加', 1, 5, nil, 'image')
    assert p1[:records].empty?
    assert_extractor tag_ids, p1[:tags]
    assert_equal 0, p1[:records_amount]
    assert_equal 0, p1[:pages_amount]
    p1 = @user2.search_media_elements('加', 1, 5, nil, 'audio')
    assert_ordered_item_extractor [@el4.id], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 1, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # fifth case - more filters
    @el6.is_public = true
    @el6.publication_date = '2011-01-01 10:00:00'
    assert_obj_saved @el6
    mee3 = MediaElement.find 3
    mee3.tags = 'torriere architettoniche, mare, petrolio, sostenibilità, di immondizia, tonquinamento atmosferico, tonquinamento, 加條聖, 條聖'
    assert_obj_saved mee3
    @el2 = MediaElement.find @el2.id
    @el2.tags = 'di escrementi di usignolo, tonquinamento atmosferico, acquario, 拿, walter nudo, mare, tonquinamento, 加條聖, 條聖'
    assert_obj_saved @el2
    MediaElement.where(:id => @el2.id).update_all(:is_public => false)
    @el2.media = {:mp4 => Rails.root.join("test/samples/one.mp4").to_s, :webm => Rails.root.join("test/samples/one.webm").to_s, :filename => "video_test"}
    MediaElement.where(:id => @el2.id).update_all(:is_public => true)
    MediaElement.where(:id => 3).update_all(:updated_at => '2012-01-01 19:59:58')
    MediaElement.where(:id => @el2.id).update_all(:updated_at => '2011-10-01 19:59:59')
    MediaElement.where(:id => @el4.id).update_all(:updated_at => '2011-10-01 19:59:57')
    assert !MediaElement.find(3).is_public
    assert_equal 2, MediaElement.find(3).user_id
    assert_equal 35, Tag.count
    assert_equal 172, Tagging.count
    p1 = @user2.search_media_elements('條聖', 1, 5, nil, 'baudio')
    assert_ordered_item_extractor [@el6.id, 3, 6, @el2.id], p1[:records]
    tag_ids = []
    Tag.where(:word => ['條聖', '條聖法話']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 4, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    p1 = @user2.search_media_elements('條聖', 1, 5, nil, 'audio')
    assert_ordered_item_extractor [3], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 1, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    p1 = @user2.search_media_elements('條聖', 1, 5, nil, 'video')
    assert_ordered_item_extractor [@el2.id], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 1, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    p1 = @user2.search_media_elements('條聖', 1, 5, nil, 'image')
    assert_ordered_item_extractor [@el6.id, 6], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 2, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    # last case
    p1 = @user2.search_media_elements('加', 1, 5, 'title')
    assert_ordered_item_extractor [@el2.id, @el4.id, 3], p1[:records]
    tag_ids = []
    Tag.where(:word => ['加', '加條聖']).each do |t|
      tag_ids << t.id
    end
    assert_extractor tag_ids, p1[:tags]
    assert_equal 3, p1[:records_amount]
    assert_equal 1, p1[:pages_amount]
    p1 = @user2.search_media_elements('加', 1, 2, 'title')
    p2 = @user2.search_media_elements('加', 2, 2, 'title')
    assert_ordered_item_extractor [@el2.id, @el4.id], p1[:records]
    assert_extractor tag_ids, p1[:tags]
    assert_equal 3, p1[:records_amount]
    assert_equal 2, p1[:pages_amount]
    assert_ordered_item_extractor [3], p2[:records]
    assert_extractor tag_ids, p2[:tags]
    assert_equal 3, p2[:records_amount]
    assert_equal 2, p2[:pages_amount]
    # check middle words
    assert_extractor [Tag.find_by_word('walter nudo').id], @user2.search_media_elements('walter ', 1, 5)[:tags]
    assert @user2.search_media_elements('nudo', 1, 5)[:tags].empty?
  end
  
end
