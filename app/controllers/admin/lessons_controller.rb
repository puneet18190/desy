class Admin::LessonsController < AdminController
  
  before_filter :find_lesson, :only => [:destroy]
  layout 'admin'
  
  def index
    lessons = params[:search] ? AdminSearchForm.search(params[:search],'lessons') : Lesson.order('id DESC')
    @lessons = lessons.page(params[:page])
    @location_root = Location.roots
    respond_to do |wants|
      wants.html
      wants.xml {render :xml => @lessons}
    end
  end
  
  def destroy
    if !@lesson.destroy
      @errors = @element.get_base_error
    end
  end
  
  private
  
  def find_lesson
    @lesson = Lesson.find(params[:id])
  end
  
end
