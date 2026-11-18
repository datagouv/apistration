require 'rails_helper'

RSpec.describe 'expired session', app: :api_entreprise do
  let(:user) { create(:user) }
  let(:endpoint_uid) { 'dgfip/liasses_fiscales' }
  let(:idle_message) { I18n.t('concerns.sessions_management.session_expired.idle', hours: 12) }
  let(:absolute_message) { I18n.t('concerns.sessions_management.session_expired.absolute', hours: 24) }

  before do
    endpoint = APIEntreprise::Endpoint.find(endpoint_uid)
    stub_request(:get, endpoint.ping_url).to_return(status: 200, body: { status: 'ok' }.to_json) if endpoint.ping_url
  end

  def sign_in_with_session(last_seen_at:, absolute_expires_at:)
    page.set_rack_session(
      current_user_id: user.id,
      last_seen_at: last_seen_at.to_i,
      absolute_expires_at: absolute_expires_at.to_i
    )
  end

  shared_examples 'a public page visited after the session expired' do |reason|
    it 'displays the public page instead of redirecting to the login' do
      visit endpoint_path(uid: endpoint_uid)

      expect(page).to have_current_path(endpoint_path(uid: endpoint_uid))
    end

    it 'tells the visitor once that their session expired' do
      visit endpoint_path(uid: endpoint_uid)

      expect(page).to have_current_path(endpoint_path(uid: endpoint_uid))
      expect(page).to have_text(expected_message)

      visit endpoint_path(uid: endpoint_uid)

      expect(page).to have_current_path(endpoint_path(uid: endpoint_uid))
      expect(page).to have_no_text(expected_message)
    end

    it 'closes the session, which no longer grants access to authenticated pages' do
      expect { visit endpoint_path(uid: endpoint_uid) }.to emit_security_event('auth.session.closed').with(
        target: { type: 'user', id: user.id },
        details: { reason: "#{reason}_timeout" }
      )

      visit user_profile_path

      expect(page).to have_current_path(login_path)
    end
  end

  context 'when idle for longer than the inactivity window' do
    let(:expected_message) { idle_message }

    before { sign_in_with_session(last_seen_at: 13.hours.ago, absolute_expires_at: 11.hours.from_now) }

    it_behaves_like 'a public page visited after the session expired', 'idle'
  end

  context 'when the absolute cap is reached despite recent activity' do
    let(:expected_message) { absolute_message }

    before { sign_in_with_session(last_seen_at: 1.minute.ago, absolute_expires_at: 1.minute.ago) }

    it_behaves_like 'a public page visited after the session expired', 'absolute'
  end

  context 'when an authenticated page is visited after the session expired' do
    before { sign_in_with_session(last_seen_at: 13.hours.ago, absolute_expires_at: 11.hours.from_now) }

    it 'redirects to the login with the expiration message only' do
      visit user_profile_path

      expect(page).to have_current_path(login_path)
      expect(page).to have_text(idle_message)
      expect(page).to have_no_text(I18n.t('concerns.sessions_management.unauthorized.signed_out.error.title'))
    end

    it 'sends a click on the logout link of a stale page to the login, not to ProConnect' do
      visit logout_path

      expect(page).to have_current_path(login_path)
      expect(page).to have_text(idle_message)
    end

    it 'emits a single closed session security event' do
      expect { visit user_profile_path }.to emit_security_event('auth.session.closed').with(
        details: { reason: 'idle_timeout' }
      )
    end
  end
end
