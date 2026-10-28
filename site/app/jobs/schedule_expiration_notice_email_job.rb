class ScheduleExpirationNoticeEmailJob < ApplicationJob
  include FriendlyDateHelper

  attr_reader :token_id, :expires_in

  NOTICE_DAYS = [0, 7, 30].freeze
  REMOVED_NOTICE_DAYS = [15, 60, 90].freeze

  queue_as :default

  def perform(token_id, expires_in)
    @token_id = token_id
    @expires_in = expires_in

    return if REMOVED_NOTICE_DAYS.include?(expires_in)
    raise ArgumentError, "No expiration notice #{expires_in} days before expiration" if NOTICE_DAYS.exclude?(expires_in)
    return if token.nil? || token.authorization_request.nil?
    return unless still_due?

    mailer_klass.with(token:, days: expires_in).expiration_notice.deliver_later
  end

  private

  def still_due?
    !token.blacklisted? && token.exp <= (expires_in + 1).days.from_now.to_i
  end

  def mailer_klass
    "API#{api.capitalize}::TokenMailer".constantize
  end

  def api
    token.api
  end

  def token
    if instance_variable_defined?(:@token)
      @token
    else
      @token = Token.find_by(id: @token_id)
    end
  end
end
