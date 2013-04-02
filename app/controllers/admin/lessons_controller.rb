class Admin::LessonsController < AdminController
  
  before_filter :find_lesson, :only => [:destroy]
  layout 'admin'
  
  def index
    lessons = params[:search] ? AdminSearchForm.search_lessons(params[:search]) : Lesson.order('id DESC')
    @lessons = lessons.page(params[:page])
    @locations = [Location.roots]
    if params[:search]
      location = Location.get_from_chain_params params[:search]
      @locations = location.get_filled_select if location
    end
    @from_reporting = params[:from_reporting]
  end
  
  def destroy
    @lesson.destroy
    redirect_to params[:back_url]
  end
  
  private
  
  def find_lesson # :doc:
    @lesson = Lesson.find(params[:id])
  end
  
end
