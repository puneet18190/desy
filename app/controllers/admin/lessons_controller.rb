# == Description
#
# Controller of lessons in the administration section. See AdminController.
#
# == Models used
#
# * AdminSearchForm
# * Lesson
# * Location
#
class Admin::LessonsController < AdminController
  
  layout 'admin'
  
  # === Description
  #
  # Main page of the section 'lessons' in admin. If params[:search] is present, it is used AdminSearchForm to perform the requested search.
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def index
    lessons = AdminSearchForm.search_lessons((params[:search] ? params[:search] : {:ordering => 0, :desc => 'true'}))
    @lessons = lessons.preload(:subject, :taggings, :taggings => :tag).page(params[:page])
    @locations = [Location.roots]
    if params[:search]
      location = Location.get_from_chain_params params[:search]
      @locations = location.get_filled_select if location
    end
    @from_reporting = params[:from_reporting]
  end
  
  # === Description
  #
  # Destroys a lesson without the normal filters
  #
  # === Mode
  #
  # Ajax
  #
  # === Specific filters
  #
  # * ApplicationController#admin_authenticate
  #
  def destroy
    @lesson = Lesson.find(params[:id])
    @lesson.destroy
    redirect_to params[:back_url]
  end
  
end
