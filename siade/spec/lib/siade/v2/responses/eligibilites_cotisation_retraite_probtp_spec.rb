RSpec.describe SIADE::V2::Responses::EligibilitesCotisationRetraitePROBTP, type: :provider_response do
  subject { request.response }

  let(:request) do
    SIADE::V2::Requests::EligibilitesCotisationRetraitePROBTP
      .new(siret)
      .perform
  end

  context 'when etablissement is not found', vcr: { cassette_name: 'probtp/eligibilite/with_not_found_siret' } do
    let(:siret) { not_found_siret(:probtp) }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }

    it 'should have code 8 and message inconnu' do
      json = JSON.parse(subject.body, symbolize_names: true)
      expect(json).to include(
        entete: {
          code:    '8',
          message: "SIRET #{siret} inconnu de nos services"
        }
      )
    end
  end

  context 'when ProBTP returns an unhandled error' do
    let(:siret) { valid_siret(:probtp) }
    let(:dummy_response) do
      {
        entete: {
          code:    'UNKNOWN CODE',
          message: 'ERROR MESSAGE'
        }
      }
    end

    before do
      stub_request(:post, /partenaires.+probtp/)
        .to_return(body: dummy_response.to_json)
    end

    its(:http_code) { is_expected.to eq(502) }
    its(:errors) { is_expected.to have_error("Erreur interne du fournisseur de données (code: UNKNOWN CODE, message: ERROR MESSAGE)") }


    describe 'monitoring service' do
      include_examples 'provider\'s response error'

      it 'logs provider error with context' do
        expect(MonitoringService.instance)
          .to receive(:track_provider_error_from_response)
          .with(
            instance_of(described_class),
            {
              internal_code:    'UNKNOWN CODE',
              internal_message: 'ERROR MESSAGE',
            }
          )

        subject
      end

      it 'sets response provider_error_custom_code to acoss_error' do
        expect(subject.provider_error_custom_code).to eq('UNKNOWN CODE')
      end
    end
  end
end
