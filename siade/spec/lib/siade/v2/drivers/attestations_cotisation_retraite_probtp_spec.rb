RSpec.describe SIADE::V2::Drivers::AttestationsCotisationRetraitePROBTP, :self_hosted_doc, type: :provider_driver do

  let(:url) { 'https://probtp_domain.gouv.fr/ws_ext/rest/certauth/mpsservices/getAttestationCotisation' }

  subject { described_class.new(siret: siret).perform_request }

  context 'siret inconnu chez PROBTP (code 8)', vcr: { cassette_name: 'probtp/attestation/with_not_found_siret' } do
    let(:siret) { not_found_siret(:probtp) }

    its(:http_code) { is_expected.to eq(404) }
  end

  context 'well formated siret' do
    context 'siret non eligible', vcr: { cassette_name: 'probtp/attestation/with_non_eligible_siret' } do
      let(:siret) { non_eligible_siret(:probtp) }

      its(:http_code) { is_expected.to eq(404) }
      its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
    end

    context 'siret eligible PROBTP', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
      let(:siret) { eligible_siret(:probtp) }

      # TODO PROBTP find a siret
      its(:http_code) { is_expected.to eq(200) }
      its(:is_pdf?, pending: 'Ask for an eligible_siret siret') { is_expected.to be true }
    end
  end

  # TODO PROBTP to remove when eligible siret found
  context 'STUB RESPONSE' do
    before do
      stub_request(:post, url)
      .with(
        body:    { corps: siret }.to_json,
        headers: { 'Content-Type' => 'application/json' })
      .to_return(stub_response)
    end

    context 'siret eligible PROBTP' do
      context 'with a valid PDF content' do
        let(:siret) { valid_siret(:probtp) }
        let(:stub_response) { { status: 200, body: "{\n  \"entete\" : {\n    \"code\" : \"0\"\n  },\n  \"data\" : \"#{encode64_payload_file('pdf/dummy.pdf')}\" }" } }

        its(:http_code) { is_expected.to eq(200) }
        its(:document_url) { is_expected.to be_a_valid_self_hosted_pdf_url('attestation_cotisation_retraite_probtp') }
      end

      context 'with an invalid PDF content' do
        let(:siret) { valid_siret(:probtp) }
        let(:stub_response) { { status: 200, body: "{\n  \"entete\" : {\n    \"code\" : \"0\"\n  },\n  \"data\" : \"oh no not a pdf\" }" } }

        its(:http_code) { is_expected.to eq(502) }
        its(:errors) { is_expected.to have_error('Erreur lors du décodage : invalide Base64 format') }
      end
    end

    describe 'non-regression test: body response empty' do
      context 'when http code is 200 but body returns an error (code 4)' do
        let(:siret) { valid_siret(:probtp) }
        let(:stub_response) { { status: 200, body: "{\"entete\":{\"code\":\"4\",\"message\":\"Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement\"}}" } }

        its(:http_code) { is_expected.to eq(502) }
        its(:errors) { is_expected.to have_error("Erreur fournisseur: Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement") }
      end
    end
  end
end
