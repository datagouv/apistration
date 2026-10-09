require 'rails_helper'

RSpec.describe 'API Particulier CNAV: Quotient Familial nom d’usage', api: :particulier do
  subject(:call_endpoint) do
    get '/v3/dss/quotient_familial/identite',
      params: {
        recipient: valid_siret,
        nomNaissance: 'CHAMPION',
        nomUsage: nom_usage,
        'prenoms[]': 'JEAN-PASCAL',
        sexeEtatCivil: 'M',
        anneeDateNaissance: 1980,
        moisDateNaissance: 6,
        jourDateNaissance: 12,
        codeCogInseePaysNaissance: '99100',
        codeCogInseeCommuneNaissance: '17300'
      },
      headers: { 'Authorization' => "Bearer #{yes_jwt}" }
  end

  let!(:cnav_authentication) { stub_cnav_authenticate('quotient_familial_v2') }

  shared_examples 'a nom d’usage rejected before calling the CNAV' do
    it 'responds with the nom d’usage validation error without calling the CNAV' do
      call_endpoint

      expect(response).to have_http_status(:unprocessable_content)
      expect(response_json[:errors].pluck(:code)).to eq(['00426'])
      expect(cnav_authentication).not_to have_been_requested
    end
  end

  context 'when the nom d’usage contains a question mark' do
    let(:nom_usage) { 'DUPONT?MARTIN' }

    it_behaves_like 'a nom d’usage rejected before calling the CNAV'
  end

  context 'when the nom d’usage contains a comma' do
    let(:nom_usage) { 'Fernandez, Franco' }

    it_behaves_like 'a nom d’usage rejected before calling the CNAV'
  end

  context 'when the nom d’usage contains a dot' do
    let(:nom_usage) { 'ST.MARTIN' }

    it_behaves_like 'a nom d’usage rejected before calling the CNAV'
  end

  context 'when the nom d’usage only contains letters, spaces, hyphens and apostrophes' do
    let(:nom_usage) { "DE L'ÉTANG-MARTIN" }
    let!(:cnav_request) { stub_cnav_valid('quotient_familial_v2', extra_params: { nomUsage: "DE L'ETANG-MARTIN" }) }

    it 'calls the CNAV' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(cnav_request).to have_been_requested
    end
  end

  context 'when the nom d’usage contains a typographic apostrophe' do
    let(:nom_usage) { 'D’ARTAGNAN' }
    let!(:cnav_request) { stub_cnav_valid('quotient_familial_v2', extra_params: { nomUsage: "D'ARTAGNAN" }) }

    it 'calls the CNAV with a straight apostrophe' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(cnav_request).to have_been_requested
    end
  end
end
