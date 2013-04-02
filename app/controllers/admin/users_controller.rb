class Admin::UsersController < AdminController
  
  layout 'admin'
  
  def index
    users = params[:search] ? AdminSearchForm.search_users(params[:search]) : User.order('id DESC')
    @users = users.page(params[:page])
    @locations = [Location.roots]
    if params[:search]
      location = Location.get_from_chain_params params[:search]
      @locations = location.get_filled_select if location
    end
  end
  
  def show
    @user = User.find(params[:id])
    Statistics.user = @user
    @user_lessons        = Lesson.where(:user_id => @user.id).order('updated_at DESC').limit(10)
    @user_elements       = MediaElement.where(:user_id => @user.id).order('updated_at DESC').limit(10)
    @my_created_lessons  = Statistics.my_created_lessons
    @my_created_elements = Statistics.my_created_elements
    @my_copied_lessons   = Statistics.my_copied_lessons
    @my_liked_lessons    = Statistics.my_liked_lessons(3)
    @my_likes_count      = Statistics.my_likes_count
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy_with_dependencies
  end
  
  def get_full_names
    @users = User.get_full_names(params[:term])
    render :json => @users
  end
  
  def find_locations
    parent = Location.find_by_id params[:id]
    @locations = parent.nil? ? [] : parent.children
  end
  
  def set_status
    @user = User.find params[:id]
    @user.active = params[:active]
    @user.save
  end
  
  def ban
    @user = User.find params[:id]
    @user.active = false
    @user.save
    redirect_to admin_user_path(@user)
  end
  
  def activate
    @user = User.find params[:id]
    @user.active = true
    @user.save
    redirect_to admin_user_path(@user)
  end
  
end
