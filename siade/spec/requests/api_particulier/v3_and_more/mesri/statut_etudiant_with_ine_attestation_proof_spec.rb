require 'rails_helper'

# Même sérialiseur, donc même builder : le contenu est couvert par statut_etudiant_attestation_proof_spec.rb.
RSpec.describe 'API Particulier MESRI: Statut étudiant by INE, attestation proof', api: :particulier do
  subject(:call_endpoint) do
    get endpoint_path, params:, headers: { 'Authorization' => "Bearer #{token}", 'X-Generate-Proof' => generate_proof }.compact
  end

  let(:endpoint_path) { '/v3/mesri/statut_etudiant/ine' }
  let(:params) { { recipient: valid_siret, ine: '1234567890A' } }
  let(:token) { yes_jwt }
  let(:generate_proof) { 'pdf' }

  before do
    Rack::Attack.reset!
    stub_mesri_valid
  end

  after { Rack::Attack.reset! }

  context 'when the proof is asked for as a PDF' do
    it 'adds the verification meta and the PDF link to the usual response' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:data][:identite]).to include(nom_naissance: 'Dupont')
      expect(response_json[:meta].keys)
        .to contain_exactly(:verification_url, :verification_code, :attestation_pdf_url_expires_in)
      expect(response_json[:links][:attestation_pdf])
        .to match(%r{\A#{AttestationToken.base_url}/api/attestations/[A-Za-z0-9_-]+(--[A-Za-z0-9_-]+)*\.pdf\z})
    end

    it 'serves the same attestation as the identity call — one serializer, one builder' do
      call_endpoint
      verification_url = response_json[:meta][:verification_url]

      get URI.parse(response_json[:links][:attestation_pdf]).path

      expect(response).to have_http_status(:ok)
      text = PDF::Reader.new(StringIO.new(response.body)).pages.map(&:text).join(' ').squish
      expect(text).to include('ATTESTATION DE STATUT ÉTUDIANT')
      expect(text).to include('Source : MESRI')
      expect(text).to include('Nom de naissance Dupont')

      annotations = HexaPDF::Document.new(io: StringIO.new(response.body)).pages.first[:Annots].to_a
      expect(annotations.filter_map { |annotation| annotation[:A]&.[](:URI) }.uniq).to eq([verification_url])
    end
  end

  context 'when no proof is asked for' do
    let(:generate_proof) { nil }

    it 'renders the response it has always rendered' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json.keys).to eq(%i[data links meta])
      expect(response_json[:links]).to eq({})
      expect(response_json[:meta]).to eq({})
    end
  end

  context 'when the header carries an unknown value' do
    let(:generate_proof) { 'banana' }

    it 'rejects the call' do
      call_endpoint

      expect(response).to have_http_status(:bad_request)
    end
  end
end
