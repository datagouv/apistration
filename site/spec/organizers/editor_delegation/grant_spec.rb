RSpec.describe EditorDelegation::Grant, type: :organizer do
  subject(:grant) { described_class.call(authorization_request:, editor_id: editor.id) }

  let(:applicant) { create(:user) }
  let(:authorization_request) { create(:authorization_request, :with_demandeur, demandeur: applicant) }
  let(:editor) { create(:editor, :delegable) }

  before { SecurityEvent.set_request_context(user: applicant, true_user: applicant) }

  it 'emits a delegation granted by the applicant' do
    expect { grant }.to emit_security_event('delegation.editor.granted').with(
      actor: { email: applicant.email, role: 'user' },
      target: { type: 'editor_delegation', id: kind_of(String) },
      details: { source: 'applicant', editor_id: editor.id, datapass_id: authorization_request.external_id }
    )
  end

  context 'when the editor does not accept delegations' do
    let(:editor) { create(:editor) }

    it 'emits no delegation granted' do
      expect { grant }.not_to emit_security_event('delegation.editor.granted')
    end
  end
end
