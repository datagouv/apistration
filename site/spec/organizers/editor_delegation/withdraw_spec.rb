RSpec.describe EditorDelegation::Withdraw, type: :organizer do
  subject(:withdraw) { described_class.call(authorization_request:, delegation_id:) }

  let(:applicant) { create(:user) }
  let(:authorization_request) { create(:authorization_request, :with_demandeur, demandeur: applicant) }
  let(:delegation) { create(:editor_delegation, authorization_request:) }

  before { SecurityEvent.set_request_context(user: applicant, true_user: applicant) }

  context 'with an active delegation of the authorization request' do
    let(:delegation_id) { delegation.id }

    it 'emits a delegation revoked by the applicant' do
      expect { withdraw }.to emit_security_event('delegation.editor.revoked').with(
        actor: { email: applicant.email, role: 'user' },
        target: { type: 'editor_delegation', id: delegation.id },
        details: { source: 'applicant', editor_id: delegation.editor_id, datapass_id: authorization_request.external_id }
      )
    end
  end

  context 'with a delegation of another authorization request' do
    let(:delegation_id) { create(:editor_delegation).id }

    it 'emits no delegation revoked' do
      expect { withdraw }.not_to emit_security_event('delegation.editor.revoked')
    end
  end
end
