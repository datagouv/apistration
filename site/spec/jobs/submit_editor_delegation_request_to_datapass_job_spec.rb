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

  context 'when DataPass stays unreachable through every attempt' do
    before { allow(datapass).to receive(:submit_demande).and_raise(DatapassAPIClient::Error.new('timeout')) }

    it 'puts the request back to submit, saying DataPass could not receive it' do
      expect {
        perform_enqueued_jobs { described_class.perform_later(editor_delegation_request.id, consents) }
      }.to raise_error(/timeout/)

      expect(editor_delegation_request.reload).not_to be_submitted
      expect(editor_delegation_request.datapass_error).to eq(described_class::UNREACHABLE_DATAPASS_REASON)
      expect(datapass).to have_received(:submit_demande).exactly(5).times
    end
  end
end
