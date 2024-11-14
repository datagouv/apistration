RSpec.describe DGFIP::ChiffresAffaires, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siret:,
      user_id:,
      request_id:
    }
  end

  let(:user_id) { yes_jwt_user.id }
  let(:request_id) { SecureRandom.uuid }
  let(:siret) { valid_siret(:exercice) }

  describe 'with valid attributes and 200 response' do
    let!(:stubbed_request) do
      mock_dgfip_authenticate

      stub_request(:get, "#{Siade.credentials[:dgfip_apim_base_url]}/adelie/v1/chiffreAffaires").with(
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => 'Bearer bearer_token',
          'X-Correlation-ID' => request_id,
          'X-Request-ID' => request_id
        },
        query: {
          'siret' => siret,
          'userId' => yes_jwt_user.id
        }
      ).to_return(
        status: 200,
        body: read_payload_file('dgfip/chiffre_affaires/valid.json')
      )
    end

    it { is_expected.to be_a_success }

    it 'calls the stubbed request', :disable_vcr do
      subject

      expect(stubbed_request).to have_been_requested
    end

    it 'retrieves the resource collection' do
      resource_collection = subject.bundled_data.data

      expect(resource_collection).to be_present
    end

    it 'has meta' do
      meta = subject.bundled_data.context

      expect(meta).to be_present
    end

    its(:cacheable) { is_expected.to be(true) }
  end

  context 'when it is not found' do
    before do
      mock_invalid_dgfip_chiffres_affaires(404)
    end

    it { is_expected.to be_a_failure }

    its(:cacheable) { is_expected.to be(false) }
  end
end
