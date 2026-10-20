RSpec.describe SimulatedDatapassWebhook do
  subject(:payload) { described_class.new(editor_delegation_request, event).payload }

  let(:event) { 'approve' }
  let(:agent) { create(:user, :with_full_name, email: 'agent@saint-exemple.fr') }
  let(:editor_delegation_request) { create(:editor_delegation_request, :submitted, :with_authorization_request, siret: '21340172201787', submitted_by_user: agent) }

  before { stub_datapass_formulaires }

  it 'builds a plausible DataPass v2 webhook for the request' do
    expect(payload).to include(event: 'approve', model_type: 'authorization_request/api_entreprise')
    expect(payload[:data]).to include(
      'state' => 'validated',
      'form_uid' => 'api-entreprise-marches-publics',
      'organization' => hash_including('siret' => '21340172201787'),
      'applicant' => hash_including('email' => 'agent@saint-exemple.fr', 'given_name' => 'Jean-Marie', 'family_name' => 'Gigot'),
      'data' => editor_delegation_request.datapass_data
    )
  end

  it 'makes up a numeric DataPass id when the request has none' do
    expect(payload[:model_id].to_s).to match(/\A\d+\z/)
    expect(payload[:model_id]).to eq(payload[:data]['id'])
  end

  context 'when the request already has a DataPass id' do
    before { editor_delegation_request.authorization_request.update!(external_id: '1054') }

    it 'reuses it' do
      expect(payload[:model_id]).to eq('1054')
    end
  end

  {
    'submit' => 'submitted',
    'refuse' => 'refused'
  }.each do |simulated_event, state|
    context "when the event is #{simulated_event}" do
      let(:event) { simulated_event }

      it { expect(payload[:data]['state']).to eq(state) }
    end
  end
end
