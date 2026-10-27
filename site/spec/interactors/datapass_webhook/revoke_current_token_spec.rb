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

    it 'emits no token revocation' do
      expect { subject }.not_to emit_security_event('token.api_token.revoked')
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

    it 'emits a token revocation effective now' do
      expect { subject }.to emit_security_event('token.api_token.revoked').with(
        target: { type: 'token', id: token.id },
        details: { datapass_id: authorization_request.external_id, blacklisted_at: be_within(1.minute).of(Time.zone.now) }
      )
    end

    it 'emits the end of each active delegation of the authorization request' do
      delegation = create(:editor_delegation, authorization_request:)

      expect { subject }.to emit_security_event('delegation.editor.revoked').with(
        target: { type: 'editor_delegation', id: delegation.id },
        details: { source: 'datapass_revoke', editor_id: delegation.editor_id, datapass_id: authorization_request.external_id }
      )
    end

    it 'emits no delegation end when the revocation rolls back' do
      create(:editor_delegation, authorization_request:)
      allow(authorization_request).to receive(:update!).and_raise(ActiveRecord::StatementInvalid)

      events = SecurityEventRecorder.new.record { expect { subject }.to raise_error(ActiveRecord::StatementInvalid) }

      expect(events.pluck(:event)).not_to include('delegation.editor.revoked')
    end

    it 'does update the authorization request status' do
      expect {
        subject
      }.to change { AuthorizationRequest.where(status: 'revoked').count }
    end
  end
end
