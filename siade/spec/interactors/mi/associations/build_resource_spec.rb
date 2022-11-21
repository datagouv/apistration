RSpec.describe MI::Associations::BuildResource, type: :build_resource do
  describe '.call', vcr: { cassette_name: 'mi/associations/with_valid_siret' } do
    subject { described_class.call(response:, params:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) do
      MI::Associations::MakeRequest.call(params:).response.body
    end

    let(:params) do
      {
        siret_or_rna: valid_rna_id
      }
    end

    let(:resource) { subject.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds valid resource' do
      expect(resource).to be_a(Resource)
    end
  end
end
