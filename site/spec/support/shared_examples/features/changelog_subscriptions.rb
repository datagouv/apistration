# frozen_string_literal: true

RSpec.shared_examples 'a changelog subscription feature' do |scope|
  describe 'subscription block on /nouveautes' do
    let(:user) { create(:user) }

    context 'when anonymous' do
      it 'shows the login invitation' do
        visit changelogs_path

        expect(page).to have_link(href: login_path)
      end
    end

    context 'when signed in and not subscribed' do
      before { login_as(user) }

      it 'shows the subscribe button' do
        visit changelogs_path

        expect(page).to have_button(I18n.t('shared.changelogs.subscription.subscribe.submit'))
      end

      it 'subscribes the user' do
        visit changelogs_path
        click_button I18n.t('shared.changelogs.subscription.subscribe.submit')

        expect(user.reload.subscribed_to_changelog?(scope)).to be true
      end
    end

    context 'when signed in and already subscribed' do
      before do
        create(:changelog_subscription, user:, scope: scope.to_s)
        login_as(user)
      end

      it 'shows the unsubscribe button' do
        visit changelogs_path

        expect(page).to have_button(I18n.t('shared.changelogs.subscription.subscribed.submit'))
      end

      it 'unsubscribes the user' do
        visit changelogs_path
        click_button I18n.t('shared.changelogs.subscription.subscribed.submit')

        expect(user.reload.subscribed_to_changelog?(scope)).to be false
      end
    end
  end

  describe 'token-based unsubscription' do
    let(:subscription) { create(:changelog_subscription, scope: scope.to_s) }

    it 'disables the subscription via token' do
      visit changelog_unsubscribe_token_path(token: subscription.unsubscribe_token)

      expect(subscription.reload.active?).to be false
    end

    it 'shows an error for an invalid token' do
      visit changelog_unsubscribe_token_path(token: 'unknown')

      expect(page).to have_current_path(changelogs_path)
    end
  end
end
