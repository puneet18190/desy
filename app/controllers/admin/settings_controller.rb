class Admin::SettingsController < AdminController
  
  layout 'admin'
  
  def index
    
  end
  
  def subjects
    @subjects = Subject.all
  end
  
  def delete_subject
    params[:id]
  end
  
  def school_levels
    @school_levels = SchoolLevel.all
  end
  
  def locations
    
  end
  
  def tags
    @tags = Tag.order('word ASC')
  end
  
end
