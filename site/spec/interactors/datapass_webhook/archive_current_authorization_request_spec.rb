require 'rails_helper'

RSpec.describe DatapassWebhook::ArchiveCurrentAuthorizationRequest, type: :interactor do
  subject { described_class.call(datapass_webhook_params.merge(authorization_request:)) }

  let(:token) { create(:token) }

  let(:authorization_request) { create(:authorization_request, tokens: [token]) }
  let(:datapass_webhook_params) { build(:datapass_webhook, event:) }

  context "when event is not 'archive'" do
    let(:event) { 'whatever' }

    it { is_expected.to be_a_success }

    it 'does not archive current authorization_request' do
      expect {
        subject
      }.not_to change { AuthorizationRequest.where(status: 'archived').count }
    end
  end

  context "when event is 'archive'" do
    let(:event) { %w[archive].sample }

    it { is_expected.to be_a_success }

    it 'updates the authorization request status' do
      expect {
        subject
      }.to change { AuthorizationRequest.where(status: 'archived').count }
    end

    context 'when the demande has no token yet' do
      let(:authorization_request) { create(:authorization_request, status: 'validated', validated_at: 1.day.ago) }

      it 'archives the demande, so that no token can be created on it' do
        subject

        expect(authorization_request.reload.status).to eq('archived')
      end
    end
  end
end
