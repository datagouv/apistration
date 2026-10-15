require 'rails_helper'

RSpec.describe 'API Particulier CNAV: Participation familiale EAJE attestation proof', api: :particulier do
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
      headers: { 'Authorization' => "Bearer #{token}", 'X-Generate-Proof' => generate_proof }.compact
  end

  let(:token) { yes_jwt }
  let(:generate_proof) { 'pdf' }

  before { stub_cnav_authenticate('participation_familiale_eaje') }

  shared_examples 'a 404 carrying the attestation proof' do |error_title:, document_title:, origin:|
    it 'keeps the error and adds the verification link and the PDF link' do
      call_endpoint

      expect(response).to have_http_status(:not_found)
      expect(response_json[:errors].pluck(:title)).to eq([error_title])
      expect(response_json[:meta].keys)
        .to contain_exactly(:verification_url, :verification_code, :attestation_pdf_url_expires_in)
      expect(response_json[:links][:attestation_pdf])
        .to match(%r{\A#{AttestationToken.base_url}/api/attestations/[A-Za-z0-9_-]+(--[A-Za-z0-9_-]+)*\.pdf\z})
    end

    it 'attests the consultation, its origin and the identity sent' do
      call_endpoint

      expect(attestation['titre']).to eq(document_title)
      expect(attestation['source']).to eq(origin)
      expect(attestation['sections'].first['entrees'].first).to include(['Erreur', error_title], ['Origine', origin])
      expect(attestation['sections'].second['entrees'].first).to include(['Nom de naissance', 'CHAMPION'], %w[Prénoms JEAN-PASCAL])
    end
  end

  shared_examples 'an error without attestation proof' do |status|
    it 'renders the error alone' do
      call_endpoint

      expect(response).to have_http_status(status)
      expect(response_json.keys).to eq([:errors])
    end
  end

  context 'when the token does not grant the children' do
    let(:token) { TokenFactory.new(Scope.all - %w[cnav_participation_familiale_eaje_enfants]).valid }

    before { stub_cnav_valid('participation_familiale_eaje') }

    it 'leaves the children out of the attestation as out of the response' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:data]).not_to have_key(:enfants)
      expect(attestation['sections'].pluck('titre')).not_to include('Enfants')
    end
  end

  context 'when the RNCPS does not reference the allocataire' do
    before { stub_rncps_404('participation_familiale_eaje') }

    it_behaves_like 'a 404 carrying the attestation proof',
      error_title: 'Allocataire non référencé', document_title: 'ATTESTATION DE CONSULTATION SANS RÉSULTAT', origin: 'RNCPS'
  end

  context 'when the CNAF has no file for the allocataire' do
    before { stub_cnav_provider_response(status: 404, regime: 'CNAF', body: read_payload_file('cnav/complementaire_sante_solidaire/404.json')) }

    it_behaves_like 'a 404 carrying the attestation proof',
      error_title: 'Dossier allocataire absent CNAF', document_title: 'ATTESTATION DE CONSULTATION SANS RÉSULTAT', origin: 'CNAF'
  end

  context 'when the MSA has no file for the allocataire' do
    before { stub_cnav_provider_response(status: 404, regime: 'MSA', body: read_payload_file('cnav/complementaire_sante_solidaire/404.json')) }

    it_behaves_like 'a 404 carrying the attestation proof',
      error_title: 'Dossier allocataire absent MSA', document_title: 'ATTESTATION DE CONSULTATION SANS RÉSULTAT', origin: 'MSA'
  end

  context 'when the allocataire has no child under 7' do
    before { stub_cnav_provider_response(status: 200, regime: 'CNAF', body: read_payload_file('cnav/participation_familiale_eaje/make_request_no_kids_under_7.json')) }

    it_behaves_like 'a 404 carrying the attestation proof',
      error_title: 'Allocataire non éligible', document_title: 'ATTESTATION DE CONSULTATION : DOSSIER NON ÉLIGIBLE', origin: 'CNAF'
  end

  context 'when the allocataire has no child under 7 and the gateway does not name the regime' do
    before { stub_cnav_provider_response(status: 200, body: read_payload_file('cnav/participation_familiale_eaje/make_request_no_kids_under_7.json')) }

    it_behaves_like 'a 404 carrying the attestation proof',
      error_title: 'Allocataire non éligible', document_title: 'ATTESTATION DE CONSULTATION : DOSSIER NON ÉLIGIBLE', origin: 'origine non communiquée'
  end

  context 'when only the proof is asked for on a 404' do
    let(:generate_proof) { 'proof-only' }

    before { stub_rncps_404('participation_familiale_eaje') }

    it 'adds the verification link without any PDF link' do
      call_endpoint

      expect(response).to have_http_status(:not_found)
      expect(response_json[:meta].keys).to contain_exactly(:verification_url, :verification_code)
      expect(response_json).not_to have_key(:links)
    end
  end

  context 'when no proof is asked for on a 404' do
    let(:generate_proof) { nil }

    before { stub_rncps_404('participation_familiale_eaje') }

    it_behaves_like 'an error without attestation proof', :not_found
  end

  context 'when the provider cannot identify the person' do
    before { stub_sngi_404('participation_familiale_eaje') }

    it_behaves_like 'an error without attestation proof', :unprocessable_content
  end

  context 'when the provider rate limits the call' do
    before { stub_cnav_provider_response(status: 429, body: '{}') }

    it_behaves_like 'an error without attestation proof', :bad_gateway
  end

  context 'when the provider fails' do
    before { stub_cnav_provider_response(status: 500, body: '{"error":"Erreur technique","errorCode":50001}') }

    it_behaves_like 'an error without attestation proof', :bad_gateway
  end

  def attestation
    pdf_token = response_json[:links][:attestation_pdf][%r{/api/attestations/(.+)\.pdf\z}, 1]

    AttestationToken.read(pdf_token, purpose: AttestationToken::PDF_PURPOSE)
  end

  def stub_cnav_provider_response(status:, body:, regime: nil)
    stub_request(:get, cnav_url('participation_familiale_eaje'))
      .with(query: hash_including({}))
      .to_return(status:, body:, headers: { 'X-APISECU-FD' => CNAV::RetrieverOrganizer::REGIME_CODE_FROM_LABEL[regime] }.compact)
  end
end
