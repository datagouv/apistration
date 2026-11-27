RSpec.describe SubmitEditorDelegationRequestToDatapassJob do
  include ActiveJob::TestHelper

  let(:editor_delegation_request) { create(:editor_delegation_request, :with_authorization_request, :with_dpo, :submitted) }
  let(:consents) { { 'terms_of_service_accepted' => true, 'data_protection_officer_informed' => true } }
  let!(:datapass) { stub_datapass_formulaires }

  context 'when DataPass already received the demande, its answer having been lost' do
    before do
      editor_delegation_request.authorization_request.update!(external_id: '1001')
      allow(datapass).to receive(:get_demande).with('1001').and_return({ 'state' => 'submitted' })
    end

    it 'leaves the demande and the request as submitted' do
      described_class.perform_now(editor_delegation_request.id, consents)

      expect(datapass).not_to have_received(:update_demande)
      expect(datapass).not_to have_received(:submit_demande)
      expect(editor_delegation_request.reload).to be_submitted
    end
  end
end
