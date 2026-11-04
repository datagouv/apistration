require 'rails_helper'

RSpec.describe 'API Particulier MESRI: Statut étudiant attestation proof', api: :particulier do
  subject(:call_endpoint) do
    get endpoint_path, params:, headers: { 'Authorization' => "Bearer #{token}", 'X-Generate-Proof' => generate_proof }.compact
  end

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

  let(:token) { yes_jwt }
  let(:generate_proof) { 'pdf' }

  before do
    Rack::Attack.reset!
    stub_mesri_with_civility_valid
  end

  after { Rack::Attack.reset! }

  context 'when the proof is asked for as a PDF' do
    it 'adds the verification meta and the PDF link to the usual response' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:meta].keys)
        .to contain_exactly(:verification_url, :verification_code, :attestation_pdf_url_expires_in)
      expect(response_json[:meta][:verification_code]).to match(/\A[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{2}\z/)
      expect(response_json[:meta][:attestation_pdf_url_expires_in]).to be_between(4.minutes.to_i, 5.minutes.to_i)
      expect(response_json[:links][:attestation_pdf])
        .to match(%r{\A#{AttestationToken.base_url}/api/attestations/[A-Za-z0-9_-]+(--[A-Za-z0-9_-]+)*\.pdf\z})
    end

    it 'leaves the delivered data alone — the proof is built beside it, not instead of it' do
      call_endpoint
      with_proof = response_json[:data]

      Rack::Attack.reset!
      without_proof = call_without_proof[:data]

      expect(with_proof).to eq(without_proof)
      expect(with_proof[:identite]).to include(nom_naissance: 'Dupont', prenom: 'Jean')
      expect(with_proof[:admissions].size).to eq(2)
    end

    it 'attests the identity and every admission the MESRI answered with' do
      call_endpoint

      expect(attestation['titre']).to eq('ATTESTATION DE STATUT ÉTUDIANT')
      expect(attestation['source']).to eq('MESRI')
      expect(attestation['sections'].pluck('titre')).to eq(%w[Étudiant Admissions])
      expect(attestation['sections'].first['entrees'].first)
        .to include(['Nom de naissance', 'Dupont'], %w[Prénom Jean], ['Date de naissance', '01/01/2000'])
      expect(attestation['sections'].second['entrees'].map { |entry| entry.to_h["État de l'inscription"] })
        .to eq(['Inscrit', 'Admis, non inscrit'])
    end
  end

  context 'when the PDF link is opened' do
    it 'serves the attestation, without authentication, pointing its QR code at the verification page' do
      call_endpoint
      verification_url = response_json[:meta][:verification_url]

      get URI.parse(response_json[:links][:attestation_pdf]).path

      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Type']).to eq('application/pdf')

      text = PDF::Reader.new(StringIO.new(response.body)).pages.map(&:text).join(' ').squish
      expect(text).to include('ATTESTATION DE STATUT ÉTUDIANT')
      expect(text).to include('Source : MESRI')
      expect(text).to include('ADMISSIONS')
      expect(text).to include('Nom de naissance Dupont')
      expect(text).to include("Établissement d'études UFR ECONOMIE UNIVERSITE PARIS 1 (75634)")

      expect(qr_target(response.body)).to eq(verification_url)
    end

    it 'refuses the link once the five minutes are over' do
      call_endpoint
      path = URI.parse(response_json[:links][:attestation_pdf]).path

      Timecop.travel(6.minutes.from_now) { get path }

      expect(response).to have_http_status(:gone)
      expect(response.body).not_to include('Dupont')
    end
  end

  context 'when the sandbox answers with mocked data' do
    let(:params) do
      super().merge(
        nomNaissance: 'CALIDONE',
        'prenoms[]': 'Lola',
        sexeEtatCivil: 'F',
        anneeDateNaissance: 2005,
        codeCogInseeCommuneNaissance: '75109'
      )
    end

    before { allow(Rails.env).to receive(:staging?).and_return(true) }

    it 'attests the mocked student, on a PDF that says it carries test data' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(attestation['sections'].first['entrees'].first).to include(['Nom de naissance', 'CALIDONE'])

      get URI.parse(response_json[:links][:attestation_pdf]).path
      text = PDF::Reader.new(StringIO.new(response.body)).pages.map(&:text).join(' ').squish

      expect(text).to include('ATTESTATION DE STATUT ÉTUDIANT')
      expect(text).to include('DONNÉES DE TEST')
    end
  end

  context 'when only the proof is asked for' do
    let(:generate_proof) { 'proof-only' }

    it 'adds the verification meta without any PDF link' do
      call_endpoint

      expect(response).to have_http_status(:ok)
      expect(response_json[:meta].keys).to contain_exactly(:verification_url, :verification_code)
      expect(response_json[:links]).to eq({})
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

  context 'when the MESRI knows no such student' do
    before { stub_mesri_with_civility_not_found }

    it 'renders the error alone — the endpoint declares no attestation of a fruitless consultation' do
      call_endpoint

      expect(response).to have_http_status(:not_found)
      expect(response_json.keys).to eq([:errors])
    end
  end

  def call_without_proof
    get endpoint_path, params:, headers: { 'Authorization' => "Bearer #{token}" }

    response_json
  end

  def attestation
    pdf_token = response_json[:links][:attestation_pdf][%r{/api/attestations/(.+)\.pdf\z}, 1]

    AttestationToken.read(pdf_token, purpose: AttestationToken::PDF_PURPOSE)
  end

  def qr_target(pdf)
    annotations = HexaPDF::Document.new(io: StringIO.new(pdf)).pages.first[:Annots].to_a

    annotations.select { |annotation| annotation[:Subtype] == :Link }.map { |annotation| annotation[:A][:URI] }.uniq.sole
  end
end
