module ChangelogSubscriptionsManagement
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, except: :destroy_via_token
  end

  def create
    current_user.changelog_subscriptions.create!(scope: namespace_scope) unless current_user.changelog_subscriptions.active.exists?(scope: namespace_scope)

    success_message(title: t('shared.changelog_subscriptions.create.success.title'))

    redirect_to changelogs_path
  end

  def destroy
    subscription = current_user.changelog_subscriptions.active.find_by(scope: namespace_scope)
    subscription&.disable!

    success_message(title: t('shared.changelog_subscriptions.destroy.success.title'))

    redirect_to changelogs_path
  end

  def destroy_via_token
    subscription = ChangelogSubscription.active.for_scope(namespace_scope).find_by(unsubscribe_token: params[:token])

    if subscription
      subscription.disable!
      success_message(title: t('shared.changelog_subscriptions.destroy_via_token.success.title'))
    else
      error_message(title: t('shared.changelog_subscriptions.destroy_via_token.error.title'))
    end

    redirect_to changelogs_path
  end

  private

  def authenticate_user!
    return if user_signed_in?

    error_message(title: t('concerns.sessions_management.unauthorized.signed_out.error.title'))

    redirect_to login_path
  end

  def namespace_scope
    namespace
  end
end
