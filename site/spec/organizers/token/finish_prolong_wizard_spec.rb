RSpec.describe Token::FinishProlongWizard, type: :organizer do
  subject(:finish) { described_class.call(prolong_token_wizard:) }

  let(:token) { create(:token, exp: 10.days.from_now.to_i) }

  context 'when the applicant asks for changes in DataPass' do
    let(:prolong_token_wizard) do
      create(:prolong_token_wizard, token:, status: 'contacts', owner: 'still_in_charge', project_purpose: false, contact_metier: true, contact_technique: true)
    end

    it 'emits no prolongation' do
      expect { finish }.not_to emit_security_event('token.api_token.prolonged')
    end
  end
end
