module UserSessionsHelper
  def user_is_demandeur?(authorization_request)
    return false unless authorization_request

    authorization_request.demandeur == current_user
  end

  def sign_in_and_redirect(user)
    return_to = sanitized_return_to_location
    start_user_session(user)

    if return_to
      redirect_to return_to
    else
      redirect_current_user_to_homepage
    end
  end

  def redirect_current_user_to_homepage
    redirect_to authorization_requests_path
  end

  def sanitized_return_to_location
    location = session[:return_to]
    return if location.blank?
    return unless location.start_with?('/')
    return if location.start_with?('//')

    location
  end

  def redirect_to_root
    redirect_to root_path
  end

  def logout_user
    clear_user_session
  end
end
