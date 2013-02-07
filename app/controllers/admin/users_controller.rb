class Admin::UsersController < ApplicationController
  before_filter :find_user, :only => [:show, :destroy]
  layout 'admin'
  def index    
    @total_users = User.sorted(params[:sort], "id DESC")
    @users = @total_users.page(params[:page])
    
    respond_to do |wants|
      wants.html # index.html.erb
      wants.xml  { render :xml => @elements }
    end
  end
  
  def show
    Statistics.user = @user
    
    @user_lessons = Lesson.joins(:user,:subject).where(user_id: @user.id).sorted(params[:sort], "lessons.id DESC")
    @user_elements = MediaElement.joins(:user).where(user_id: @user.id).sorted(params[:sort], "media_elements.id DESC")
    
    @my_created_lessons  = Statistics.my_created_lessons.count
    @my_created_elements = Statistics.my_created_elements.count
    @my_copied_lessons   = Statistics.my_copied_lessons
    @my_liked_lessons    = Statistics.my_liked_lessons(3)
    @my_likes_count      = Statistics.my_likes_count
  end

  def destroy
    @user.destroy

    respond_to do |wants|
      wants.html { redirect_to(elements_url) }
      wants.xml  { head :ok }
    end
  end

  private
    def find_user
      @user = User.find(params[:id])
    end

end
