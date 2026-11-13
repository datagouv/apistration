require 'rails_helper'

RSpec.describe 'API Particulier CNAV: Participation familiale EAJE dossier allocataire', api: :particulier do
  subject(:call_endpoint) do
    get '/v3/dss/participation_familiale_eaje/identite',
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

  let(:token) { yes_jwt }
  let(:caf_body) { read_payload_file('cnav/participation_familiale_eaje/make_request_valid.json') }

  before { stub_cnav_authenticate('participation_familiale_eaje') }

  context 'when the allocataire belongs to a CAF' do
    before { stub_cnav_provider_response(regime: 'CNAF', body: caf_body) }

    it 'renders the CAF matricule as a string and the CAF code' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:data][:dossier_allocataire]).to eq(matricule_caf: '1863617', code_organisme_caf: '061')
    end
  end

  context 'when the allocataire belongs to the MSA, which does not send the CAF file' do
    let(:msa_body) { JSON.parse(caf_body).except('matriculeCaf', 'codeOrganismeCaf').to_json }

    before { stub_cnav_provider_response(regime: 'MSA', body: msa_body) }

    it 'keeps the object with both fields set to null' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:data][:dossier_allocataire]).to eq(matricule_caf: nil, code_organisme_caf: nil)
    end
  end

  context 'when the token does not grant the dossier allocataire' do
    let(:token) { TokenFactory.new(Scope.all - %w[cnav_participation_familiale_eaje_dossier_allocataire]).valid }

    before { stub_cnav_provider_response(regime: 'CNAF', body: caf_body) }

    it 'leaves the key out of the response' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:data]).not_to have_key(:dossier_allocataire)
      expect(response_json[:data]).to have_key(:allocataires)
    end
  end

  def stub_cnav_provider_response(regime:, body:)
    stub_request(:get, cnav_url('participation_familiale_eaje'))
      .with(query: hash_including({}))
      .to_return(status: 200, body:, headers: { 'X-APISECU-FD' => CNAV::RetrieverOrganizer::REGIME_CODE_FROM_LABEL[regime] })
  end
end
