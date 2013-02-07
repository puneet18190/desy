class UsersController < ApplicationController
  
  skip_before_filter :authenticate, only: [:create, :confirm, :request_reset_password, :reset_password]
  before_filter :initialize_layout, :only => [:edit, :update, :subjects, :statistics, :mailing_lists]
  layout 'prelogin', only: [:create, :request_reset_password]

  def create
    email = params[:user].try(:delete, :email)
    @user = User.new(params[:user]) do |user|
      user.email = email
      user.confirmed = false
    end

    if @user.save
      redirect_to root_path(login: true), { flash: { notice: t('flash.successful_registration') } }
      UserMailer.account_confirmation(@user, request.host, request.port).deliver
    else
      @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
      @location_ids     = Location.order(:description).map{ |l| [l.to_s, l.id] }
      @subjects         = Subject.order(:description)

      render 'prelogin/registration'
    end
  end

  def confirm
    if User.confirm!(params[:token])
      redirect_to root_path(login: true), { flash: { notice: t('flash.successful_confirmation') } }
    else
      redirect_to root_path, { flash: { alert: t('flash.failed_confirmation') } }
    end
  end

  def request_reset_password
  end

  def reset_password
    email = params[:email]
    if email.blank?
      redirect_to user_request_reset_password_path, { flash: { alert: t('flash.email_is_blank') } } 
      return
    end

    if user = User.confirmed.where(email: email).first
      new_password = user.reset_password!
      UserMailer.new_password(user, new_password, request.host, request.port).deliver
    end

    redirect_to root_path, { flash: { notice: t('flash.password_reset_successfully') } }
  end
  
  def edit
    @user = current_user
    @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
    @location_ids     = Location.order(:description).map{ |l| [l.to_s, l.id] }
  end

  def subjects
    @user = current_user
    @subjects = Subject.order(:description)
  end

  def update
    @user = current_user
    in_subjects = !!params[:in_subjects]

    if in_subjects
      params[:user] ||= HashWithIndifferentAccess.new
      params[:user][:subject_ids] ||= []
    else
      password = params[:user].try(:[], :password)
      if !password || password.empty?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
    end
    
    if @user.update_attributes(params[:user])
      redirect_to in_subjects ? my_subjects_path : my_profile_path
    else
      if in_subjects
        @subjects = Subject.order(:description)
        render :subjects
      else
        @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
        @location_ids     = Location.order(:description).map{ |l| [l.to_s, l.id] }
        render :edit
      end
    end
  end
  
  def mailing_lists
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
    self.current_user = nil
    redirect_to root_path
  end
  
end
