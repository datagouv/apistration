RSpec.describe INSEE::SiegeUniteLegale::BuildResource, type: :build_resource do
  subject { organizer }

  let(:organizer) { described_class.call(response:) }
  let(:response) { instance_double('Net::HTTPOK', body:) }

  let(:body) do
    INSEE::SiegeUniteLegale::MakeRequest.call(params:, token:).response.body
  end

  let(:token) { INSEE::Authenticate.call.token }
  let(:params) do
    {
      siren:
    }
  end

  context 'with valid siren', vcr: { cassette_name: 'insee/siege/active_GE_with_token' } do
    let(:siren) { sirens_insee_v3[:active_GE] }

    it { is_expected.to be_a_success }

    describe 'resource' do
      subject { organizer.resource }

      it { is_expected.to be_a(Resource) }

      its(:id) { is_expected.to eq("#{siren}01294") }
      its(:siege_social) { is_expected.to be(true) }
    end
  end
end
