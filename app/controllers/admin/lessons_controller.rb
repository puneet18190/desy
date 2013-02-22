class Admin::LessonsController < AdminController
  before_filter :find_lesson, :only => [:destroy]
  layout 'admin'
  def index
    #@lessons = Lesson.order('id DESC').page params[:page] #to manage others search
    #@lessons = Lesson.joins(:user,:subject,:likes).select('lessons.*, users.name, subjects.description, count(likes) AS likes_count').group('lessons.id').sorted(params[:sort], "lessons.id DESC").page(params[:page])
    if AdminSearchForm.search(params[:search],'lessons')
      @total_lessons = AdminSearchForm.search(params[:search],'lessons')
    else
      @total_lessons = Lesson.order('id DESC')
    end
    @lessons = @total_lessons.page(params[:page])
    @location_root = Location.roots
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @lessons }
    end
  end

  def destroy
    @lesson.destroy

    respond_to do |wants|
      wants.html { redirect_to(lessons_url) }
      wants.xml  { head :ok }
    end
  end

  private
    def find_lesson
      @lesson = Lesson.find(params[:id])
    end

end
