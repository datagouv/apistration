RSpec.describe SIADE::V2::Drivers::EligibilitesCotisationRetraitePROBTP, type: :provider_driver do
  subject { described_class.new(siret: siret).perform_request }

  context 'with siret eligible PROBTP', vcr: { cassette_name: 'probtp/eligibilite/with_eligible_siret' } do
    let(:siret) { eligible_siret(:probtp) }

    its(:http_code) { is_expected.to eq(200) }
    its(:eligible?) { is_expected.to be true }
    its(:message) { is_expected.to eq('00 Compte éligible pour attestation de cotisation') }
  end

  context 'with siret non eligible PROBTP', vcr: { cassette_name: 'probtp/eligibilite/with_non_eligible_siret' } do
    let(:siret) { non_eligible_siret(:probtp) }

    its(:http_code) { is_expected.to eq(200) }
    its(:eligible?) { is_expected.to be false }
    its(:message) { is_expected.to eq('01 Compte non éligible pour attestation de cotisation') }
  end

  context 'with siret inconnu chez PROBTP', vcr: { cassette_name: 'probtp/eligibilite/with_not_found_siret' } do
    let(:siret) { not_found_siret(:probtp) }

    its(:http_code) { is_expected.to eq(404) }
    its(:errors) { is_expected.to have_error("Le siret ou siren indiqué n'existe pas, n'est pas connu ou ne comporte aucune information pour cet appel") }
    its(:eligible?) { is_expected.to be false }
    its(:message) { is_expected.to eq("SIRET #{siret} inconnu de nos services") }
  end

  context 'when ProBTP returns an invalid message' do
    let(:siret) { valid_siret(:probtp) }
    let(:dummy_response) do
      {
        entete: {
          code: '0',
          message: 'ERROR MESSAGE'
        },
        corps: 'UNHANDLED CORPS'
      }
    end

    before do
      stub_request(:post, /partenaires.+probtp/)
        .to_return(body: dummy_response.to_json)
    end

    its(:http_code) { is_expected.to eq(200) }
    its(:eligible?) { is_expected.to be false }
    its(:message) { is_expected.to eq('UNHANDLED CORPS') }

    it 'logs provider error with context' do
      expect(MonitoringService.instance)
        .to receive(:track_provider_error_from_response)
        .with(
          instance_of(described_class),
          {
            internal_code: '0',
            error_message: 'ERROR MESSAGE',
            corps: 'UNHANDLED CORPS'
          }
        )

      subject.eligible?
    end

    it 'sets provider_error_custom_code with internal code' do
      subject.eligible?

      expect(subject.provider_error_custom_code).to eq('0')
    end
  end
end
