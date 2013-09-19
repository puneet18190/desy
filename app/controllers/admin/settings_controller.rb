# == Description
#
# Controller for minor tables, such as +tags+ and +subjects+. See AdminController
#
# == Models used
#
# * Subject
# * SchoolLevel
# * AdminSearchForm
# * Tag
#
class Admin::SettingsController < AdminController
  
  layout 'admin'
  
  # === Description
  #
  # Main subpage to manage subjects
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def subjects
    @subjects = Subject.select('subjects.*, ((SELECT COUNT (*) FROM users_subjects WHERE users_subjects.subject_id = subjects.id) + (SELECT COUNT (*) FROM lessons WHERE lessons.subject_id = subjects.id)) AS instances')
  end
  
  # === Description
  #
  # Action that creates a new subject
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def new_subject
    Subject.create(:description => params[:description]) if params[:description]
    redirect_to '/admin/settings/subjects'
  end
  
  # === Description
  #
  # Action that deletes a subject; it's possible to do it only if the subject doesn't have associated users or lessons (see Subject#is_deletable?)
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def delete_subject
    @id = params[:id]
    subject = Subject.find(@id)
    subject.destroy if subject.is_deletable?
  end
  
  # === Description
  #
  # Main subpage to manage school levels
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def school_levels
    @school_levels = SchoolLevel.select('school_levels.*, ((SELECT COUNT (*) FROM users WHERE users.school_level_id = school_levels.id) + (SELECT COUNT (*) FROM lessons WHERE lessons.school_level_id = school_levels.id)) AS instances')
  end
  
  # === Description
  #
  # Action that creates a new school level
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def new_school_level
    SchoolLevel.create(:description => params[:description]) if params[:description]
    redirect_to '/admin/settings/school_levels'
  end
  
  # === Description
  #
  # Action that deletes a school level; it's possible to do it only if the school level doesn't have associated users or lessons (see SchoolLevel#is_deletable?)
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def delete_school_level
    @id = params[:id]
    level = SchoolLevel.find(@id)
    level.destroy if level.is_deletable?
  end
  
  # === Description
  #
  # Main subpage to manage tags. If params[:search] is present, it is used AdminSearchForm to perform the requested search.
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def tags
    tags = AdminSearchForm.search_tags((params[:search] ? params[:search] : {:ordering => 2, :desc => 'true'}))
    @tags = tags.page(params[:page])
  end
  
  # === Description
  #
  # Action that deletes a tag; with the cascade destruction, all taggings are destroyed too (in this case it's not validated the minimum amount of tags)
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def delete_tag
    if correct_integer? params[:id]
      @id = params[:id].to_i
      tag = Tag.find_by_id @id
      tag.destroy if !tag.nil?
    end
    redirect_to params[:back_url]
  end
  
  # === Description
  #
  # 'Show' action for all the lessons associated to a given tag
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def lessons_for_tag
    @tag = Tag.find(params[:id])
    @lessons = @tag.get_lessons(params[:page]).select('lessons.*, (SELECT COUNT (*) FROM likes WHERE likes.lesson_id = lessons.id) AS likes_count').preload(:user, :subject, :taggings, :taggings => :tag)
    covers = Slide.where(:lesson_id => @lessons.pluck(:id), :kind => 'cover').preload(:media_elements_slides, :media_elements_slides => :media_element)
    @covers = {}
    covers.each do |cov|
      @covers[cov.lesson_id] = cov
    end
  end
  
  # === Description
  #
  # 'Show' action for all the elements associated to a given tag
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def media_elements_for_tag
    @tag = Tag.find(params[:id])
    @media_elements = @tag.get_media_elements(params[:page]).preload(:user, :taggings, :taggings => :tag)
  end
  
end
