class Admin::SettingsController < AdminController
  
  layout 'admin'
  
  def index
    
  end
  
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
  
  def locations
    
  end
  
  def tags
    @tags = Tag.order('word ASC')
    if params[:id]
      @tag = Tag.where(id: params[:id]).first
      @lessons = @tag.get_lessons if @tag.present?
      @media_elements = @tag.get_media_elements if @tag.present?
    end
  end
  
  def delete_tag
    @id = params[:id]
    tag = Tag.find(@id)
    tag.destroy
    
    redirect_to '/admin/settings/tags'
  end
  
end
