require 'rails_helper'

RSpec.describe 'API Particulier MESRI: Statut étudiant attestation proof in production', api: :particulier do
  subject(:call_endpoint) do
    get endpoint_path, params:, headers: { 'Authorization' => "Bearer #{yes_jwt}", 'X-Generate-Proof' => generate_proof }.compact
  end

  let(:generate_proof) { 'pdf' }

  let(:response_without_header) do
    get endpoint_path, params:, headers: { 'Authorization' => "Bearer #{yes_jwt}" }
    response.parsed_body
  end

  before do
    Rack::Attack.reset!
    allow(Rails.env).to receive(:production?).and_return(true)
  end

  after { Rack::Attack.reset! }

  shared_examples 'a student status call that ignores the proof header' do
    it 'renders the response of a call without the header when a PDF is asked for' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq(response_without_header)
    end

    context 'when the header carries an unknown value' do
      let(:generate_proof) { 'banana' }

      it 'does not reject the call' do
        call_endpoint

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to eq(response_without_header)
      end
    end
  end

  describe 'the call by INE' do
    let(:endpoint_path) { '/v3/mesri/statut_etudiant/ine' }
    let(:params) { { recipient: valid_siret, ine: '1234567890A' } }

    before { stub_mesri_valid }

    it_behaves_like 'a student status call that ignores the proof header'
  end

  describe 'the call by identity' do
    let(:endpoint_path) { '/v3/mesri/statut_etudiant/identite' }
    let(:params) do
      {
        recipient: valid_siret,
        nomNaissance: 'DUPONT',
        'prenoms[]': 'JEAN',
        sexeEtatCivil: 'M',
        anneeDateNaissance: 2000,
        moisDateNaissance: 1,
        jourDateNaissance: 1,
        codeCogInseeCommuneNaissance: '75113'
      }
    end

    before { stub_mesri_with_civility_valid }

    it_behaves_like 'a student status call that ignores the proof header'
  end
end
