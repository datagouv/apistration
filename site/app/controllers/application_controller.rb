class ApplicationController < ActionController::Base
  include Pundit::Authorization

  include UserSessionsHelper

  helper UserSessionsHelper

  helper ActiveLinks

  helper_method :namespace, :current_user, :user_signed_in?

  SESSION_INACTIVITY_TIMEOUT = 12.hours

  before_action :enforce_session_inactivity_timeout

  def current_user
    @current_user ||= session[:current_user_id] &&
                      User.find(session[:current_user_id])
  rescue ActiveRecord::RecordNotFound
    session[:current_user_id] = nil
    nil
  end

  impersonates :user

  def user_signed_in?
    !current_user.nil?
  end

  rescue_from Pundit::NotAuthorizedError do |_|
    error_message(title: t('.error.unauthorize'))
    redirect_current_user_to_homepage
  end

  rescue_from ActiveRecord::RecordNotFound do |_|
    error_message(title: t('.error.record_not_found'))
    if user_signed_in?
      redirect_current_user_to_homepage
    else
      redirect_to_root
    end
  end

  def error_message(title:, description: nil, id: nil)
    flash_message(:error, title:, description:, id:)
  end

  def success_message(title:, description: nil, id: nil)
    flash_message(:success, title:, description:, id:)
  end

  def info_message(title:, description: nil, id: nil)
    flash_message(:info, title:, description:, id:)
  end

  private

  def enforce_session_inactivity_timeout
    return if session[:current_user_id].blank?

    if session_inactive?
      reset_session
      info_message(title: t('concerns.sessions_management.inactivity_timeout.title', hours: SESSION_INACTIVITY_TIMEOUT.in_hours.to_i))
      redirect_to login_path
      return
    end

    session[:last_seen_at] = Time.current.to_i
  end

  def session_inactive?
    last_seen_at = session[:last_seen_at]

    last_seen_at.nil? || Time.current.to_i - last_seen_at > SESSION_INACTIVITY_TIMEOUT.to_i
  end

  def namespace
    host_segments = request.host.split('.')
    return 'particulier' if host_segments.include?('particulier')
    return 'entreprise' if host_segments.include?('entreprise')

    raise "Unknown namespace for host: #{request.host}"
  end

  def flash_message(kind, title:, description:, id:)
    flash[kind] ||= {}
    flash[kind]['title'] = title
    flash[kind]['description'] = description
    flash[kind]['id'] = id
  end
end
