class UsersController < ApplicationController
  
  skip_before_filter :authenticate, only: [:create, :confirm, :request_reset_password, :reset_password]
  before_filter :initialize_layout, :only => [:edit, :subjects, :statistics]
  layout 'prelogin', only: [:create, :request_reset_password]

  def create
    email = params[:user].try(:delete, :email)
    @user = User.new(params[:user]) do |user|
      user.email = email
      user.confirmed = false
    end

    if @user.save
      redirect_to root_path, { flash: { notice: t('captions.successful_registration') } }
      UserMailer.account_confirmation(@user, request.host, request.port).deliver
    else
      @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
      @location_ids     = Location.order(:description).map{ |l| [l.to_s, l.id] }
      @subjects         = Subject.order(:description)

      render 'prelogin/registration'
    end
  end

  def confirm
    flash =
      if User.confirm!(params[:token])
        { notice: t('captions.successful_confirmation') }
      else
        { alert: t('captions.failed_confirmation') }
      end

    redirect_to root_path, { flash: flash }
  end

  def request_reset_password
  end

  def reset_password
    email = params[:email]
    if email.blank?
      redirect_to user_request_reset_password_path, { flash: { alert: t('captions.email_is_blank') } } 
      return
    end

    if user = User.confirmed.where(email: email).first
      new_password = user.reset_password!
      UserMailer.new_password(user, new_password, request.host, request.port).deliver
    end

    redirect_to root_path, { flash: { notice: t('captions.password_resetted_successfully') } } 
  end
  
  def edit
  end

  def update
  end
  
  def subjects
  end

  def statistics
    Statistics.user = current_user

    @my_created_lessons  = Statistics.my_created_lessons
    @my_created_elements = Statistics.my_created_elements
    @my_copied_lessons   = Statistics.my_copied_lessons
    @my_liked_lessons    = Statistics.my_liked_lessons(3)
    @all_liked_lessons   = Statistics.all_liked_lessons(3)
    @my_likes_count      = Statistics.my_likes_count
    @all_shared_elements = Statistics.all_shared_elements
    @all_shared_lessons  = Statistics.all_shared_lessons
    @all_users           = Statistics.all_users
    @all_users_like      = Statistics.all_users_like
    @all_subjects_chart  = Statistics.all_subjects_chart[0].split(',')
    @all_subjects_desc   = Statistics.all_subjects_chart[1].split(',')
  end
  
  def logout
    session[:user_id] = nil
    redirect_to '/'
  end
  
end
