RSpec.describe SIADE::V2::Responses::AttestationsCotisationRetraitePROBTP, type: :provider_response do
  subject { described_class.new(raw_response) }

  let(:siret) { not_found_siret(:probtp) }
  let(:url) { 'https://probtp_domain.gouv.fr/ws_ext/rest/certauth/mpsservices/getAttestationCotisation' }
  let(:raw_response) do
    request = SIADE::V2::Requests::AttestationsCotisationRetraitePROBTP.new(siret)
    request.perform
    request.raw_response
  end

  context 'when etablissement is not found', vcr: { cassette_name: 'probtp/attestation/with_not_found_siret' } do
    let(:siret) { not_found_siret(:probtp) }

    its(:http_code) { is_expected.to eq(404) }

    it 'has code 8 and message inconnu' do
      json = JSON.parse(subject.body, symbolize_names: true)
      expect(json[:entete][:code]).to include('8')
      expect(json[:entete][:message]).to include("SIRET #{siret} inconnu de nos services")
    end
  end

  context 'when there\'s an internal error from provider which is a valid json' do
    before do
      stub_request(:post, url).to_return(stub_response)
    end

    let(:stub_response) { { status: 200, body: '{"entete":{"code":"4","message":"Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement"}}' } }

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error('Erreur fournisseur: Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement') }

    include_examples 'provider\'s response error'
  end

  context 'when there\'s an internal error from provider which is not a valid json' do
    before do
      stub_request(:post, url).to_return(stub_response)
    end

    let(:stub_response) { { status: 200, body: '<H1>SRVE0255E: A WebGroup/Virtual Host to handle /ws_ext/rest/certauth/mpsservices/getAttestationCotisation has not been defined.</H1><BR>H3><SRVE0255E: A WebGroup/Virtual Host to handle partenaires.webservices.probtp.com:443 has not been defined./H3><BR>' } }

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error('Mauvaise réponse envoyée par le fournisseur de données') }

    include_examples 'provider\'s response error'
  end
end
