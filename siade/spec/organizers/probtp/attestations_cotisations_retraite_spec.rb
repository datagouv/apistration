RSpec.describe PROBTP::AttestationsCotisationsRetraite, :self_hosted_doc do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siret:
      }
    end

    context 'when the attestation is found', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
      let(:siret) { eligible_siret(:probtp) }

      it { is_expected.to be_success }

      it 'uploads the attestation on the self hosted storage' do
        document_url = subject.bundled_data.data.document_url

        expect(document_url).to be_a_valid_self_hosted_pdf_url('attestation_cotisation_retraite_probtp')
      end
    end

    context 'when the attestation is not found', vcr: { cassette_name: 'probtp/attestation/with_not_found_siret' } do
      let(:siret) { not_found_siret(:probtp) }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to have_error("Le siret ou le siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel. Veuillez vérifier que votre recherche est couverte par le périmètre de l'API.") }
    end

    describe 'STUBBED PROVIDER RESPONSES' do
      let(:siret) { eligible_siret(:probtp) }
      let(:stubbed_response) { { status: 200, body: mocked_body } }

      before do
        stub_request(:post, "#{Siade.credentials[:probtp_domain]}/ws_ext/rest/certauth/mpsservices/getAttestationCotisation")
          .with(
            body: { corps: siret }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(stubbed_response)
      end

      context 'when the PDF is not valid' do
        let(:mocked_body) { "{\n  \"entete\" : {\n    \"code\" : \"0\"\n  },\n  \"data\" : \"oh no not a pdf\" }" }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to have_error('Erreur lors du décodage : invalide Base64 format') }
      end

      context 'when there is an internal error from PROBTP (expected JSON error)' do
        let(:mocked_body) { '{"entete":{"code":"4","message":"Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement"}}' }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to have_error('Erreur fournisseur: Une erreur est survenue, merci de bien vouloir renouveler votre demande ultérieurement') }
      end
    end
  end
end
