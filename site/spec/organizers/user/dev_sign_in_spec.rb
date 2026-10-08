require 'rails_helper'

RSpec.describe User::DevSignIn, type: :organizer do
  subject(:sign_in) { described_class.call(email:) }

  let!(:user) { create(:user, email: 'test@example.com') }

  context 'when the email belongs to a user' do
    let(:email) { 'TEST@example.com' }

    it { is_expected.to be_a_success }

    it 'returns the user' do
      expect(sign_in.user).to eq(user)
    end
  end

  context 'when no user has this email' do
    let(:email) { 'nobody@example.com' }

    it { is_expected.to be_a_failure }

    it 'tells why' do
      expect(sign_in.message).to eq('unknown_user')
    end

    it 'emits a denied dev login attempt' do
      expect { sign_in }.to emit_security_event('auth.login.attempted').with(
        actor: { email: nil, role: 'anonymous' },
        details: { method: 'dev_login', reason: 'unknown_user', outcome: 'denied' }
      )
    end
  end
end
