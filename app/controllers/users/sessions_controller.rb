class Users::SessionsController < ApplicationController
  
  skip_before_filter :authenticate, only: :create

  # def login
  #   # FIXME provvisorio
  #   login_hash = {
  #     CONFIG['admin_email'] => 'desymorgan',
  #     'desy1@morganspa.com' => 'desymorgan1',
  #     'desy2@morganspa.com' => 'desymorgan2',
  #     'desy3@morganspa.com' => 'desymorgan3',
  #     'desy4@morganspa.com' => 'desymorgan4',
  #     'desy5@morganspa.com' => 'desymorgan5',
  #     'desy6@morganspa.com' => 'desymorgan6',
  #     'toostrong@morganspa.com' => 'bellaperme',
  #     'fupete@morganspa.com' => 'bellaperte',
  #     'jeg@morganspa.com' => 'bellaperlui',
  #     'holly@morganspa.com' => 'bellapernoi',
  #     'benji@morganspa.com' => 'bellapervoi',
  #     'retlaw@morganspa.com' => 'bellaperloro'
  #   }
  #   if params[:email].blank? || params[:password].blank?
  #     @error = t('captions.fill_all_login_fields')
  #     render 'login_error.js'
  #     return
  #   end
  #   if !login_hash.has_key?(params[:email]) || login_hash[params[:email]] != params[:password] || User.find_by_email(params[:email]).nil?
  #     @error = t('captions.password_or_username_not_correct')
  #     render 'login_error.js'
  #     return
  #   end
  #   session[:user_id] = User.find_by_email(params[:email]).id
  #   # FINO A QUI
  #   @redirect = session[:prelogin_request]
  #   session[:prelogin_request] = nil
  #   @redirect = '/dashboard' if @redirect.blank?
  #   render 'login_ok.js'
  # end
  def create
    if params[:email].blank? || params[:password].blank?
      # flash[:error] = 
      redirect_to home_path, flash: { error: t('captions.fill_all_login_fields') }
      return
      # render 'login_error.js'
      # return
    end
    self.current_user = User.authenticate(params[:email], params[:password])

    redirect_url = params[:redirect_to]
    redirect_path = dashboard_path

    redirect_to
      if current_user

        if redirect_url
          begin
            url = URI.parse(redirect_url)
            if url.path
              redirect_path = url.path
              redirect_path << "?#{url.query}" if url.query
              redirect_path << "##{url.fragment}" if url.fragment
          rescue URI::InvalidURIError, URI::BadURIError
          end
        end

        redirect_path
      else
        home_path, flash: { error: t('captions.password_or_username_not_correct') }
      end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
  
end
