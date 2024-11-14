RSpec.describe DGFIP::LiassesFiscales, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:annee) { 2017 }
  let(:siren) { valid_siren(:liasse_fiscale) }
  let(:user_id) { yes_jwt_user.id }
  let(:params) do
    {
      siren:,
      year: annee,
      user_id:,
      request_id:
    }
  end
  let(:request_id) { SecureRandom.uuid }

  context 'when found' do
    let!(:stubbed_request) do
      mock_dgfip_authenticate
      mock_valid_dgfip_dictionnaire(annee)

      stub_request(:get, "#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/getLiasseFiscale").with(
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer bearer_token',
          'X-Correlation-ID' => request_id,
          'X-Request-ID' => request_id
        },
        query: {
          'siren' => siren,
          'userId' => yes_jwt_user.id,
          'annee' => annee
        }
      ).to_return(
        status: 200,
        body: read_payload_file('dgfip/liasses_fiscales/obligation_fiscale_simplified.json')
      )
    end

    it { is_expected.to be_a_success }

    it 'calls the stubbed request', :disable_vcr do
      subject

      expect(stubbed_request).to have_been_requested
    end

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present
    end

    its(:cacheable) { is_expected.to be(true) }
  end

  context 'when not found' do
    before do
      mock_invalid_dgfip_liasse_fiscale(404)
    end

    it { is_expected.to be_a_failure }

    its(:cacheable) { is_expected.to be(true) }
  end
end
