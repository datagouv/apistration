module NewsletterSubscriptionsManagement
  extend ActiveSupport::Concern

  HONEYPOT_FIELD = :reference

  included do
    rate_limit to: 3, within: 1.minute, by: -> { request.remote_ip }, only: :create,
      store: Rails.application.config.rate_limit_store, scope: 'newsletter_subscriptions', with: -> { reject_too_many_subscriptions }
  end

  def create
    if subscription_params[HONEYPOT_FIELD].present?
      confirm_subscription_request
    elsif subscription_email.match?(URI::MailTo::EMAIL_REGEXP)
      subscribe_to_newsletter
    else
      reject_subscription(:invalid_email)
    end
  end

  def confirmed
    success_message(title: t('shared.newsletter_subscriptions.confirmed.title'), description: t('shared.newsletter_subscriptions.confirmed.description'))
    redirect_to newsletter_path
  end

  private

  def subscribe_to_newsletter
    BrevoAPIClient.new.subscribe_with_double_optin(
      email: subscription_email,
      list_ids: [BrevoSettings.list_id(api)],
      template_id: BrevoSettings.newsletter_template_id(api),
      redirection_url: "#{request.protocol}#{SiteHost.for(namespace)}#{newsletter_confirmed_path}"
    )
    confirm_subscription_request
  rescue Faraday::Error => e
    Sentry.capture_exception(e)
    reject_subscription(:brevo_error)
  end

  def confirm_subscription_request
    success_message(title: t('shared.newsletter_subscriptions.create.success.title'), description: t('shared.newsletter_subscriptions.create.success.description'))
    redirect_to newsletter_path
  end

  def reject_subscription(reason)
    error_message(title: t("shared.newsletter_subscriptions.create.error.#{reason}"))
    redirect_to newsletter_path
  end

  def reject_too_many_subscriptions
    reject_subscription(:too_many_requests)
  end

  def subscription_email
    subscription_params[:email].to_s.strip
  end

  def subscription_params
    params.expect(newsletter_subscription: [:email, HONEYPOT_FIELD])
  end

  def api
    namespace.delete_prefix('api_')
  end
end
