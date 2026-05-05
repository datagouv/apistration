class APIParticulier::ChangelogMailer < APIParticulierMailer
  before_action :attach_logos

  helper :application
  helper :mailer_url

  def weekly(subscription_id, entry_attributes)
    @subscription = ChangelogSubscription.find(subscription_id)
    @user = @subscription.user
    @entries = entry_attributes.map { |attrs| ChangelogEntry.new(**attrs.symbolize_keys) }

    mail(to: @user.email, subject: t('api_particulier.changelog_mailer.weekly.subject')) { |format| format.html }
  end
end
