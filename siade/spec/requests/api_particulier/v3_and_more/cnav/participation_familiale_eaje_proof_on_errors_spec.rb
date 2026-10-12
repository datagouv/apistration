require 'rails_helper'

RSpec.describe 'API Particulier CNAV: EAJE X-Generate-Proof on errors that earn no proof', api: :particulier do
  let(:params) do
    {
      recipient: '13002526500013',
      nomNaissance: 'CHAMPION',
      prenoms: %w[JEAN-PASCAL],
      sexeEtatCivil: 'M',
      anneeDateNaissance: 1980,
      moisDateNaissance: 6,
      jourDateNaissance: 12,
      codeCogInseePaysNaissance: '99100',
      codeCogInseeCommuneNaissance: '17300'
    }
  end
  let(:cnav_request) { stub_request(:get, cnav_url('participation_familiale_eaje')).with(query: hash_including({})) }
  let(:rncps) { { 'X-APISECU-FD' => CNAV::RetrieverOrganizer::REGIME_CODE_RNCPS } }
  let(:no_child_under_7) { read_payload_file('cnav/participation_familiale_eaje/make_request_no_kids_under_7.json') }

  before { stub_cnav_authenticate('participation_familiale_eaje') }

  after { Rack::Attack.reset! }

  def call_eaje(proof:)
    headers = { 'Authorization' => "Bearer #{yes_jwt}" }
    headers['X-Generate-Proof'] = 'pdf' if proof

    get '/v3/dss/participation_familiale_eaje/identite', params:, headers:
  end

  shared_examples 'an error answered without proof' do |status|
    it "answers #{status} with X-Generate-Proof exactly as without it" do
      call_eaje(proof: false)
      body_without_header = response.body

      expect(response).to have_http_status(status)

      call_eaje(proof: true)

      expect(response).to have_http_status(status)
      expect(response.body).to eq(body_without_header)
    end
  end

  context 'when our own params validation fails' do
    let(:params) { super().merge(sexeEtatCivil: 'X') }

    it_behaves_like 'an error answered without proof', 422
  end

  context 'when the SNGI does not identify the person' do
    before { stub_sngi_404('participation_familiale_eaje') }

    it_behaves_like 'an error answered without proof', 422
  end

  context 'when the CNAV rejects the civility' do
    before { stub_cnav_400('participation_familiale_eaje', error_code: 40_001, error: 'Civilité rejetée') }

    it_behaves_like 'an error answered without proof', 422
  end

  context 'when the CNAV answers 429' do
    before { cnav_request.to_return(status: 429, body: '{}') }

    it_behaves_like 'an error answered without proof', 502
  end

  context 'when the CNAV answers 500' do
    before { cnav_request.to_return(status: 500, body: { errorCode: 50_001, error: 'Erreur technique' }.to_json) }

    it_behaves_like 'an error answered without proof', 502
  end

  context 'when the CNAV times out' do
    before { cnav_request.to_timeout }

    it_behaves_like 'an error answered without proof', 504
  end

  context 'when the RNCPS reports no file' do
    before { cnav_request.to_return(status: 404, headers: rncps, body: { errorCode: 40_401, error: 'Dossier absent' }.to_json) }

    it_behaves_like 'an error answered without proof', 404
  end

  context 'when a file with no child under 7 comes without a regime' do
    before { cnav_request.to_return(status: 200, body: no_child_under_7) }

    it_behaves_like 'an error answered without proof', 404
  end

  context 'when a file with no child under 7 comes from the RNCPS' do
    before { cnav_request.to_return(status: 200, headers: rncps, body: no_child_under_7) }

    it_behaves_like 'an error answered without proof', 404
  end
end
