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
    @tags = Tag.order('word ASC').limit(40)
    if params[:id]
      @tag = Tag.where(id: params[:id]).first
      @lessons = @tag.get_lessons(params[:lessons_page]) if @tag.present?
      @media_elements = @tag.get_media_elements(params[:elements_page]) if @tag.present?
    end
  end
  
  def select_tags
    @tag = Tag.find_by_id params[:id]
    if @tag
      @lessons = @tag.get_lessons(1) if @tag.present?
      @media_elements = @tag.get_media_elements(1) if @tag.present?
    end
  end
  
  def tags_new_block
    @tags = Tag.limit(40).offset(params[:offset])
  end
  
  def delete_tag
    @id = params[:id]
    tag = Tag.find(@id)
    tag.destroy
  end
  
end
