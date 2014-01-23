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
  
  skip_before_filter :authenticate, :only => [
    :create,
    :confirm,
    :request_reset_password,
    :reset_password,
    :send_reset_password,
    :request_upgrade_trial,
    :send_upgrade_trial,
    :find_locations
  ]
  before_filter :initialize_layout, :only => [
    :edit,
    :update,
    :subjects,
    :statistics,
    :mailing_lists,
    :trial,
    :logged_upgrade_trial
  ]
  layout 'fullpage_notification', :only => [
    :request_reset_password,
    :reset_password,
    :send_reset_password,
    :request_upgrade_trial,
    :send_upgrade_trial,
    :confirm,
    :create
  ]
  
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
    saas = SETTINGS['saas_registration_mode']
    if saas
      @trial            = params[:trial] == '1'
      purchase = Purchase.find_by_token params[:purchase_id]
    end
    @user = User.active.not_confirmed.new(params[:user]) do |user|
      user.email = email
      key_last_location = SETTINGS['location_types'].last.downcase
      if params.has_key?(:location) && params[:location].has_key?(key_last_location) && params[:location][key_last_location].to_i != 0
        user.location_id = params[:location][key_last_location]
      end
      user.purchase_id = @trial ? nil : (purchase ? purchase.id : 0) if saas
    end
    if @user.save
      UserMailer.account_confirmation(@user).deliver
      if saas
        if @user.trial?
          Notification.send_to @user.id, t('notifications.account.trial',
            :user_name => @user.name,
            :desy      => SETTINGS['application_name'],
            :validity  => SETTINGS['saas_trial_duration'],
            :link      => upgrade_trial_link
          )
        else
          Notification.send_to @user.id, t('notifications.account.welcome',
            :user_name       => @user.name,
            :desy            => SETTINGS['application_name'],
            :expiration_date => TimeConvert.to_string(purchase.expiration_date)
          )
        end
        purchase = @user.purchase
        UserMailer.purchase_full(purchase).deliver if purchase && User.where(:purchase_id => purchase.id).count >= purchase.accounts_number
      end
      render 'users/fullpage_notifications/confirmation/email_sent'
    else
      @errors = convert_user_error_messages @user.errors
      location = Location.get_from_chain_params params[:location]
      @locations = location.nil? ? [{:selected => 0, :content => Location.roots.order(:name)}] : location.get_filled_select_for_personal_info
      @school_level_ids = SchoolLevel.order(:description).map{ |sl| [sl.to_s, sl.id] }
      @subjects         = Subject.extract_with_cathegories
      render 'prelogin/registration', :layout => 'prelogin'
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
      render 'users/fullpage_notifications/confirmation/received'
    else
      render 'users/fullpage_notifications/expired_link'
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
      UserMailer.new_password(user).deliver
    end
    render 'users/fullpage_notifications/reset_password/email_sent'
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
      UserMailer.new_password_confirmed(user, new_password).deliver
      render 'users/fullpage_notifications/reset_password/received'
    else
      render 'users/fullpage_notifications/expired_link'
    end
  end
  
  # === Description
  #
  # Opens the page where the user writes an email and a purchase code to upgrade his trial account
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def request_upgrade_trial
    if !SETTINGS['saas_registration_mode']
      redirect_to root_path
      return
    end
  end
  
  # === Description
  #
  # Sends to the user an email containing the upgrade trial token
  #
  # === Mode
  #
  # Html
  #
  # === Skipped filters
  #
  # * ApplicationController#authenticate
  #
  def send_upgrade_trial
    if !SETTINGS['saas_registration_mode']
      redirect_to root_path
      return
    end
    if params[:email].blank? || params[:password].blank? || params[:purchase_id].blank?
      redirect_to user_request_upgrade_trial_path, { flash: { alert: t('flash.upgrade_trial.missing_fields') } }
      return
    end
    user = User.active.confirmed.where(:email => params[:email]).first
    if !user || !user.trial? || !user.valid_password?(params[:password])
      redirect_to user_request_upgrade_trial_path, { flash: { alert: t('flash.upgrade_trial.wrong_login_or_not_trial') } }
      return
    end
    purchase = Purchase.find_by_token(params[:purchase_id])
    if !purchase || purchase.users.count >= purchase.accounts_number
      redirect_to user_request_upgrade_trial_path, { flash: { alert: t('flash.upgrade_trial.purchase_token_not_valid') } }
      return
    end
    user.purchase_id = purchase.id
    user.location_id = purchase.location_id if purchase.location && purchase.location.sti_type == SETTINGS['location_types'].last
    if !user.save
      redirect_to user_request_upgrade_trial_path, { flash: { alert: t('flash.upgrade_trial.generic_error') } }
      return
    end
    Notification.send_to user.id, t('notifications.account.upgraded', :expiration_date => TimeConvert.to_string(purchase.expiration_date))
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
    @errors = convert_user_error_messages @user.errors
    @school_levels = SchoolLevel.order(:description)
    location = @user.location
    if @user.purchase && @user.purchase.location
      @forced_location = @user.purchase.location
      if location && location.is_descendant_of?(@forced_location)
        @locations = location.get_filled_select_for_personal_info
      else
        @locations = @forced_location.get_filled_select_for_personal_info
      end
    else
      @locations = location.nil? ? [{:selected => 0, :content => Location.roots.order(:name)}] : location.get_filled_select_for_personal_info
    end
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
    @parent = Location.find_by_id params[:id]
    @locations = @parent.nil? ? [] : @parent.children.order(:name)
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
    @subjects = Subject.extract_with_cathegories
  end
  
  # === Description
  #
  # Sends to the user an email containing the upgrade trial token
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  #
  def logged_upgrade_trial
    if !current_user.trial?
      redirect_to my_profile_path
      return
    end
    user = current_user
    purchase = Purchase.find_by_token(params[:purchase_id])
    if !purchase || purchase.users.count >= purchase.accounts_number
      @error = t('users.trial.errors.code_not_valid')
      render 'trial'
      return
    end
    user.purchase_id = purchase.id
    user.location_id = purchase.location_id if purchase.location && purchase.location.sti_type == SETTINGS['location_types'].last
    if !user.save
      @error = t('users.trial.errors.problem_saving')
      render 'trial'
      return
    end
    Notification.send_to user.id, t('notifications.account.upgraded', :expiration_date => TimeConvert.to_string(purchase.expiration_date))
    redirect_to dashboard_path, { flash: { notice: t('users.trial.successful_upgrade') } }
  end
  
  # === Description
  #
  # Section of your profile about trial version handling
  #
  # === Mode
  #
  # Html
  #
  # === Specific filters
  #
  # * ApplicationController#initialize_layout
  #
  def trial
    if !current_user.trial?
      redirect_to my_profile_path
      return
    end
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
    key_last_location = SETTINGS['location_types'].last.downcase
    if params.has_key?(:location) && params[:location].has_key?(key_last_location) && params[:location][key_last_location].to_i != 0
      @user.location_id = params[:location][key_last_location]
    end
    @user.name = params[:name]
    @user.surname = params[:surname]
    @user.school_level_id = params[:school_level_id]
    if params[:password] && params[:password].present?
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
    end
    if @user.save
      redirect_to my_profile_path, { flash: { notice: t('users.info.ok_popup') } }
    else
      @errors = convert_user_error_messages @user.errors
      if @errors[:subjects].any? || @errors[:policies].any?
        redirect_to my_profile_path, { flash: { notice: t('users.info.wrong_popup') } }
      else
        @errors = @errors[:general]
        @locations = Location.get_from_chain_params(params[:location]).get_filled_select_for_personal_info
        @forced_location = @user.purchase.location if @user.purchase && @user.purchase.location
        @school_levels = SchoolLevel.order(:description)
        render :edit
      end
    end
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
  def update_subjects
    @user = current_user
    params[:user][:subject_ids] ||= []
    if @user.update_attributes(params[:user])
      redirect_to my_subjects_path, { flash: { notice: t('users.subjects.ok_popup') } }
    else
      @errors = convert_user_error_messages @user.errors
      if @errors[:general].any? || @errors[:policies].any?
        redirect_to my_profile_path, { flash: { notice: t('users.subjects.wrong_popup') } }
      else
        @subjects = Subject.extract_with_cathegories
        render :subjects
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
    @my_created_lessons      = Statistics.my_created_lessons
    @my_created_elements     = Statistics.my_created_elements
    @my_copied_lessons       = Statistics.my_copied_lessons
    @my_liked_lessons        = Statistics.my_liked_lessons(3)
    @my_linked_lessons_count = Statistics.my_linked_lessons_count
    @all_liked_lessons       = Statistics.all_liked_lessons(3)
    @my_likes_count          = Statistics.my_likes_count
    @all_shared_elements     = Statistics.all_shared_elements
    @all_shared_lessons      = Statistics.all_shared_lessons
    @all_users               = Statistics.all_users
    @all_users_like          = Statistics.all_users_like(3)
    @subjects_chart          = {
      :data   => Statistics.subjects_chart,
      :texts  => Statistics.subjects,
      :colors => Subject.chart_colors
    }
  end
  
  private
  
  def upgrade_trial_link
    my_trial_path
  end
  
end
