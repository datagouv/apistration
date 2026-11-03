module ChangelogMailersCommons
  extend ActiveSupport::Concern

  included do
    before_action :attach_logos

    helper :application
    helper :mailer_url
  end

  def weekly(subscription_id, entry_attributes)
    @subscription = ChangelogSubscription.find(subscription_id)
    @user = @subscription.user
    @entries = entry_attributes.map { |attrs| ChangelogEntry.new(**attrs.symbolize_keys) }

    mail(to: @user.email, subject: t('mailers.changelog_mailer.weekly.subject', api_name: api_full_name))
  end
end
