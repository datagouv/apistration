require 'rails_helper'

RSpec.describe User::ProconnectSignIn, type: :organizer do
  subject(:sign_in) { described_class.call(provider:, omniauth_auth:, ip: '203.0.113.4') }

  let(:user) { create(:user) }
  let(:provider) { 'proconnect_api_entreprise' }
  let(:acr) { 'eidas1-mfa' }
  let(:omniauth_auth) do
    OmniAuth::AuthHash.new(
      info: { 'email' => user.email, 'first_name' => 'John', 'last_name' => 'Doe', 'uid' => '123456' },
      extra: { acr: }
    )
  end

  before { allow(MonitoringService.instance).to receive(:track) }

  context 'when ProConnect authenticated the user with MFA' do
    it { is_expected.to be_a_success }

    it 'returns the user' do
      expect(sign_in.user).to eq(user)
    end
  end

  context 'when the provider is not ours' do
    let(:provider) { 'evil_provider' }

    it { is_expected.to be_a_failure }

    it 'tells why' do
      expect(sign_in.message).to eq('invalid_provider')
    end

    it 'tracks the attempt' do
      sign_in

      expect(MonitoringService.instance).to have_received(:track).with(
        'OAuth security: Invalid provider attempt',
        level: 'info',
        context: { provider:, ip: '203.0.113.4' }
      )
    end
  end

  context 'when OmniAuth data is missing' do
    let(:omniauth_auth) { nil }

    it { is_expected.to be_a_failure }

    it 'tells why' do
      expect(sign_in.message).to eq('missing_omniauth_data')
    end
  end

  context 'when ProConnect did not perform MFA' do
    let(:acr) { 'eidas1' }

    it { is_expected.to be_a_failure }

    it 'tells why' do
      expect(sign_in.message).to eq('mfa_missing')
    end

    it 'does not create nor update the user' do
      expect { sign_in }.not_to(change { user.reload.attributes })
    end
  end
end
