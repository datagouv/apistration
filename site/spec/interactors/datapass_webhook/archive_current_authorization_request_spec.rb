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
  end

  context "when event is 'archive' on an editor delegation request without token" do
    let(:event) { 'archive' }
    let(:authorization_request) { create(:authorization_request) }
    let!(:delegation) { create(:editor_delegation, authorization_request:) }

    before { create(:editor_delegation_request, authorization_request:) }

    it 'archives the authorization request and revokes its delegation' do
      subject

      expect(authorization_request.reload).to be_archived
      expect(delegation.reload.revoked_at).to be_present
    end
  end
end
