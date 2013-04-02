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
  
  def subjects
    @subjects = Subject.all
  end
  
  def new_subject
    Subject.create(:description => params[:description]) if params[:description]
    redirect_to '/admin/settings/subjects'
  end
  
  def delete_subject
    @id = params[:id]
    subject = Subject.find(@id)
    subject.destroy if subject.is_deletable?
  end
  
  def school_levels
    @school_levels = SchoolLevel.all
  end
  
  def new_school_level
    SchoolLevel.create(:description => params[:description]) if params[:description]
    redirect_to '/admin/settings/school_levels'
  end
  
  def delete_school_level
    @id = params[:id]
    level = SchoolLevel.find(@id)
    level.destroy if level.is_deletable?
  end
  
  def tags
    tags = params[:search] ? AdminSearchForm.search_tags(params[:search]) : Tag.order('created_at DESC')
    @tags = tags.page(params[:page])
  end
  
  def delete_tag
    if correct_integer? params[:id]
      @id = params[:id].to_i
      tag = Tag.find_by_id @id
      tag.destroy if !tag.nil?
    end
    redirect_to params[:back_url]
  end
  
  def lessons_for_tag
    @tag = Tag.find(params[:id])
    @lessons = @tag.get_lessons(params[:page])
  end
  
  def media_elements_for_tag
    @tag = Tag.find(params[:id])
    @media_elements = @tag.get_media_elements(params[:page])
  end
  
end
