require 'rails_helper'

RSpec.describe 'API Particulier CNAV: Foyer RSA scopes', api: :particulier do
  subject(:call_endpoint) do
    get '/v3/dss/foyer_rsa/identite',
      params: {
        recipient: valid_siret,
        nomNaissance: 'CHAMPION',
        'prenoms[]': 'JEAN-PASCAL',
        sexeEtatCivil: 'M',
        anneeDateNaissance: 1980,
        moisDateNaissance: 6,
        jourDateNaissance: 12,
        codeCogInseePaysNaissance: '99100',
        codeCogInseeCommuneNaissance: '17300'
      },
      headers: { 'Authorization' => "Bearer #{token}" }
  end

  before do
    stub_cnav_authenticate('foyer_rsa')
    stub_cnav_valid('foyer_rsa')
  end

  context 'with the beneficiaires scope only' do
    let(:token) { TokenFactory.new(Scope.all - %w[cnav_foyer_rsa_personnes_a_charge]).valid }

    it 'renders the beneficiaires without the personnes à charge' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:data].keys).to eq(%i[beneficiaires])
    end
  end

  context 'with the personnes à charge scope only' do
    let(:token) { TokenFactory.new(Scope.all - %w[cnav_foyer_rsa_beneficiaires]).valid }

    it 'renders the personnes à charge without the beneficiaires' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:data].keys).to eq(%i[personnes_a_charge])
    end
  end
end
