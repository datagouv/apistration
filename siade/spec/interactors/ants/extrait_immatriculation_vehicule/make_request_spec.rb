RSpec.describe ANTS::ExtraitImmatriculationVehicule::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) { {} }
    let!(:stubbed_request) do
      stub_request(post, Siade.credentials[:provider_url]).with(body:)
    end

    let(:body) do
      request_params.to_json
    end

    let(:request_params) do
      {
        immatriculation: 'AA-123-AA',
        given_name: 'Jean',
        family_name: 'DUPONT',
        birthdate: '2000-10-01',
        gender: 'male',
        birthplace: nil,
        birthcountry: '12345'
      }
    end

    describe 'Implements endpoint', pending: 'Implement endpoint' do
      it { is_expected.to be_a_success }
    end

    it 'calls url with correct params', pending: 'Implement endpoint' do
      subject

      expect(stubbed_request).to have_been_requested
    end
  end
end
