module UserSessionsHelper
  def user_is_demandeur?(authorization_request)
    return false unless authorization_request

    authorization_request.demandeur == current_user
  end

  def sign_in_and_redirect(user)
    session[:current_user_id] = user.id
    session[:last_seen_at] = Time.current.to_i
    redirect_current_user_to_homepage
  end

  def redirect_current_user_to_homepage
    redirect_to authorization_requests_path
  end

  def redirect_to_root
    redirect_to root_path
  end

  def logout_user
    session[:current_user_id] = nil
    session[:last_seen_at] = nil
  end
end
