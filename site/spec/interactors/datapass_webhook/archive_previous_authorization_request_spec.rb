require 'rails_helper'

RSpec.describe DatapassWebhook::ArchivePreviousAuthorizationRequest, type: :interactor do
  subject { described_class.call(datapass_webhook_params.merge(authorization_request:)) }

  let(:authorization_request) { create(:authorization_request, previous_external_id:) }
  let(:datapass_webhook_params) { build(:datapass_webhook, event:) }

  let(:token) { create(:token) }

  before do
    create(:authorization_request, tokens: [token], external_id: previous_external_id) if previous_external_id
  end

  context 'when event is approve or validate' do
    let(:event) { %w[approve validate].sample }

    context 'when authorization request has a previous external id' do
      let(:previous_external_id) { generate(:authorization_request, :external_id) }

      it 'archives previous authorization request' do
        expect {
          subject
        }.to change { AuthorizationRequest.where(status: 'archived').count }
      end

      it 'emits the end of the delegations of the previous authorization request' do
        delegation = create(:editor_delegation, authorization_request: AuthorizationRequest.find_by(external_id: previous_external_id))

        expect { subject }.to emit_security_event('delegation.editor.revoked').with(
          target: { type: 'editor_delegation', id: delegation.id },
          details: hash_including(source: 'datapass_archive', datapass_id: previous_external_id)
        )
      end
    end

    context 'when authorization request has no previous external id' do
      let(:previous_external_id) { nil }

      it 'does nothing' do
        expect {
          subject
        }.not_to change { AuthorizationRequest.where(status: 'archived').count }
      end
    end
  end

  context 'when event is not approve' do
    let(:event) { %w[send_application submit] }

    context 'when authorization request has a previous external id' do
      let(:previous_external_id) { generate(:authorization_request, :external_id) }

      it 'does nothing' do
        expect {
          subject
        }.not_to change { AuthorizationRequest.where(status: 'archived').count }
      end
    end
  end
end
