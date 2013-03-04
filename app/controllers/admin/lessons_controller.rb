class Admin::LessonsController < AdminController
  before_filter :find_lesson, :only => [:destroy]
  layout 'admin'
  def index
    #@lessons = Lesson.order('id DESC').page params[:page] #to manage others search
    #@lessons = Lesson.joins(:user,:subject,:likes).select('lessons.*, users.name, subjects.description, count(likes) AS likes_count').group('lessons.id').sorted(params[:sort], "lessons.id DESC").page(params[:page])
    if params[:search]
      lessons = AdminSearchForm.search(params[:search],'lessons')
    else
      lessons = Lesson.order('id DESC')
    end
    @lessons = lessons.page(params[:page])
    @location_root = Location.roots
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @lessons }
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
