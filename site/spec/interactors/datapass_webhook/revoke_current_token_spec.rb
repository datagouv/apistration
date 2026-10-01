require 'rails_helper'

RSpec.describe DatapassWebhook::RevokeCurrentToken, type: :interactor do
  subject { described_class.call(datapass_webhook_params.merge(authorization_request:)) }

  let(:token) { create(:token) }

  let(:authorization_request) { create(:authorization_request, tokens: [token]) }
  let(:datapass_webhook_params) { build(:datapass_webhook, event:) }

  context "when event is not 'revoke'" do
    let(:event) { 'whatever' }

    it { is_expected.to be_a_success }

    it 'does not archive current token' do
      expect {
        subject
      }.not_to change { Token.where.not(blacklisted_at: nil).count }
    end
  end

  context "when event is 'revoke'" do
    let(:event) { %w[revoke].sample }

    it { is_expected.to be_a_success }

    it 'does revoke current token' do
      expect {
        subject
      }.to change { Token.where.not(blacklisted_at: nil).count }
    end

    it 'does update the authorization request status' do
      expect {
        subject
      }.to change { AuthorizationRequest.where(status: 'revoked').count }
    end
  end

  context "when event is 'revoke' on an editor delegation request without token" do
    let(:event) { 'revoke' }
    let(:authorization_request) { create(:authorization_request) }
    let!(:delegation) { create(:editor_delegation, authorization_request:) }

    before { create(:editor_delegation_request, authorization_request:) }

    it 'revokes the authorization request and its delegation' do
      subject

      expect(authorization_request.reload.status).to eq('revoked')
      expect(delegation.reload.revoked_at).to be_present
    end
  end
end
