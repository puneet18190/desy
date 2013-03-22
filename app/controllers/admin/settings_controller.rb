class Admin::SettingsController < AdminController
  
  layout 'admin'
  
  
  # SUBJECTS
  
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
  
  
  # SCHOOL LEVELS
  
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
  
  
  # TAGS
  
  def tags
    tags = params[:search] ? AdminSearchForm.search_tags(params[:search]) : Tag.order('created_at DESC')
    @tags = tags.page(params[:page])
  end
  
  def delete_tag
    
  end
  
  def lessons_for_tag
    
  end
  
  def media_elements_for_tag
    
  end
  
end
