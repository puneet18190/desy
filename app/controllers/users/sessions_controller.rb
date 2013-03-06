class Users::SessionsController < ApplicationController
  
  skip_before_filter :authenticate, only: [:create, :destroy]

  def create
    redirect_to_param = params[:redirect_to]
    path_params = { login: true }
    path_params[:redirect_to] = redirect_to_param if redirect_to_param.present?

    redirect_args =
      if params[:email].blank? || params[:password].blank?
        failed_authentication_redirect_args path_params, t('other_popup_messages.login.missing_fields')
      else
        self.current_user = User.authenticate(params[:email], params[:password])

        if current_user
          uri_path_and_query(redirect_to_param) || [dashboard_path]
        else
          failed_authentication_redirect_args path_params, t('other_popup_messages.login.wrong_content')
        end
      end

    redirect_to *redirect_args
  end

  def destroy
    self.current_user = nil
    redirect_to root_path
  end

  private
  def failed_authentication_redirect_args(path_params, error)
    [ root_path(path_params), { flash: { alert: error } } ]
  end

  def uri_path_and_query(url)
    return nil unless url

    components = URI.split url

    # Scheme, Userinfo, Host, Port, Registry, Opaque
    invalid_components_indexes = [0, 1, 2, 3, 4, 6]
    # Path, Query (Fragment is unuseful, ignoring it)
    valid_components_indexes = [5, 7]

    return nil if components.values_at(*invalid_components_indexes).compact.present?

    path, query = components.values_at(*valid_components_indexes)
    return nil if path.blank?

    path << "?#{query}" if query
    
    [path]
  rescue URI::InvalidURIError, URI::BadURIError
  end
  
end
