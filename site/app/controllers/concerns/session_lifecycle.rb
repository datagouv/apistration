module SessionLifecycle
  extend ActiveSupport::Concern

  SESSION_INACTIVITY_TIMEOUT = 12.hours
  SESSION_ABSOLUTE_TIMEOUT = 24.hours

  ROTATION_PRESERVED_KEYS = %w[
    omniauth.pc.access_token
    omniauth.pc.id_token
    omniauth.pc.refresh_token
  ].freeze

  included do
    before_action :enforce_session_timeouts
    after_action :show_expiry_notice_once
  end

  private

  def enforce_session_timeouts
    return if session[:current_user_id].blank?

    if session_inactive?
      expire_session('idle')
    elsif session_absolute_timeout_reached?
      expire_session('absolute')
    else
      session[:last_seen_at] = Time.current.to_i
    end
  end

  def start_user_session(user, siret: nil)
    rotate_session

    session[:current_user_id] = user.id
    session[:current_user_siret] = siret
    session[:last_seen_at] = Time.current.to_i
    session[:absolute_expires_at] = SESSION_ABSOLUTE_TIMEOUT.from_now.to_i
  end

  def clear_user_session
    session[:current_user_id] = nil
    session[:current_user_siret] = nil
    session[:last_seen_at] = nil
    session[:absolute_expires_at] = nil
  end

  def rotate_session
    preserved = ROTATION_PRESERVED_KEYS.index_with { |key| session[key] }.compact
    reset_session
    preserved.each { |key, value| session[key] = value }
  end

  def session_inactive?
    last_seen_at = session[:last_seen_at]

    last_seen_at.nil? || Time.current.to_i - last_seen_at > SESSION_INACTIVITY_TIMEOUT.to_i
  end

  def session_absolute_timeout_reached?
    absolute_expires_at = session[:absolute_expires_at]

    absolute_expires_at.nil? || Time.current.to_i >= absolute_expires_at
  end

  def expire_session(reason)
    User::CloseSession.call(user: current_user, reason: "#{reason}_timeout")
    reset_session
    forget_expired_user
    info_message(title: t("concerns.sessions_management.session_expired.#{reason}", hours: timeout_hours(reason)))
  end

  def forget_expired_user
    @session_expired = true
    @current_user = nil
    stop_impersonating_user
    SecurityEvent.set_request_context(user: nil, true_user: nil)
  end

  def show_expiry_notice_once
    flash.discard(:info) if @session_expired && !response.redirect?
  end

  def flash_sign_in_required
    return if @session_expired

    error_message(title: t('concerns.sessions_management.unauthorized.signed_out.error.title'))
  end

  def timeout_hours(reason)
    duration = reason == 'idle' ? SESSION_INACTIVITY_TIMEOUT : SESSION_ABSOLUTE_TIMEOUT

    duration.in_hours.to_i
  end
end
