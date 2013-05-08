# == Description
#
# Controller for actions related to user's profile and statistics
#
# == Models used
#
# * User
# * UserMailer
# * Location
# * Subject
# * SchoolLevel
#
# == Subcontrollers
#
# * Users::SessionsController
#
class UsersController < ApplicationController
  
  skip_before_filter :authenticate, :only => [:create, :confirm, :request_reset_password, :reset_password, :send_reset_password, :find_locations]
  before_filter :initialize_layout, :only => [:edit, :update, :subjects, :statistics, :mailing_lists]
  layout 'prelogin', :only => [:create, :request_reset_password]
  
  # === Description
  #
  # Creates a profile which is not confirmed yet
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def create
    email = params[:user].try(:delete, :email)
    @user = User.active.not_confirmed.new(params[:user]) do |user|
      user.email = email
      user.location_id = params[:location][SETTINGS['location_types'].last.downcase] if params[:location].has_key? SETTINGS['location_types'].last.downcase
    end
    if @user.save
      UserMailer.account_confirmation(@user, request.host, request.port).deliver
      render 'users/fullpage_notifications/confirmation/email_sent', :layout => 'ad_hoc'
    else
      @errors = convert_user_error_messages @user.errors
      location = Location.get_from_chain_params params[:location]
      @locations = location.nil? ? [{:selected => 0, :content => Location.roots}] : location.get_filled_select_for_personal_info
      @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
      @subjects         = Subject.order(:description)
      render 'prelogin/registration'
    end
  end
  
  # === Description
  #
  # Confirms a profile using the link with token received by e-mail by the user
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def confirm
    if User.confirm!(params[:token])
      render 'users/fullpage_notifications/confirmation/received', :layout => 'prelogin'
    else
      render 'users/fullpage_notifications/expired_link', :layout => 'prelogin'
    end
  end
  
  # === Description
  #
  # Opens the page where the user writes an email to reset the password
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def request_reset_password
  end
  
  # === Description
  #
  # Sends to the user an email containing the reset password token
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def send_reset_password
    email = params[:email]
    if email.blank?
      redirect_to user_request_reset_password_path, { flash: { alert: t('flash.email_is_blank') } }
      return
    end
    if user = User.active.confirmed.where(email: email).first
      user.password_token!
      UserMailer.new_password(user, request.host, request.port).deliver
    end
    render 'users/fullpage_notifications/reset_password/email_sent', :layout => 'prelogin'
  end
  
  # === Description
  #
  # Checks the token and resets the password; sends to the user an email containing the new password
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def reset_password
    new_password, user = *User.reset_password!(params[:token])
    if new_password
      UserMailer.new_password_confirmed(user, new_password, request.host, request.port).deliver
      render 'users/fullpage_notifications/reset_password/received', :layout => 'prelogin'
    else
      render 'users/fullpage_notifications/expired_link', :layout => 'prelogin'
    end
  end
  
  # === Description
  #
  # Form to edit the general information about your profile
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  #
  def edit
    @user = current_user
    @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
    fill_locations
  end
  
  # === Description
  #
  # Necessary to fill the locations list
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def find_locations
    parent = Location.find_by_id params[:id]
    @locations = parent.nil? ? [] : parent.children
  end
  
  # === Description
  #
  # Form to edit your list of subjects
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  #
  def subjects
    @user = current_user
    @subjects = Subject.order(:description)
  end
  
  # === Description
  #
  # Updates your profile (it can be called either from UsersController#edit or from UsersController#subjects)
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  #
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
      @errors = convert_user_error_messages @user.errors
      if in_subjects
        @subjects = Subject.order(:description)
        render :subjects
      else
        fill_locations
        @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
        render :edit
      end
    end
  end
  
  # === Description
  #
  # Manage your mailing lists and addresses (see MailingListsController)
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  #
  def mailing_lists
  end
  
  # === Description
  #
  # Static page with general and personal statistics
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  #
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
    @all_users_like      = Statistics.all_users_like(3)
    @subjects_chart      = {
      :data   => Statistics.subjects_chart,
      :texts  => Statistics.subjects,
      :colors => Subject.chart_colors
    }
  end
  
  private
  
  # Fills the locations
  def fill_locations
    @user_location = {}
    prev_location = User.find(current_user.id).location
    SETTINGS['location_types'].reverse.each do |l|
      @user_location[l.downcase] = prev_location.id
      prev_location = prev_location.parent
    end
    @locations = Location.get_from_chain_params(@user_location).get_filled_select
  end
  
end
