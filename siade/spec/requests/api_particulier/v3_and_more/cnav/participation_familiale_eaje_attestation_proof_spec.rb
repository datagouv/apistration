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

  def attestation
    pdf_token = response_json[:links][:attestation_pdf][%r{/api/attestations/(.+)\.pdf\z}, 1]

    AttestationToken.read(pdf_token, purpose: AttestationToken::PDF_PURPOSE)
  end
end
