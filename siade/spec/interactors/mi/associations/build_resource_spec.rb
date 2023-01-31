RSpec.describe MI::Associations::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(response:, params:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:params) do
      {
        siret_or_rna: valid_rna_id
      }
    end

    describe 'happy path' do
      let(:body) do
        open_payload_file('mi/association-77567227238579.xml').read
      end

      let(:resource) { subject.bundled_data.data }

      it { is_expected.to be_a_success }

      it 'builds valid resource' do
        expect(resource).to be_a(Resource)
      end
    end

    describe 'when payload has only one dac document (non-regression test)' do
      let(:body) do
        open_payload_file('mi/association-77567227238579-1dac.xml').read
      end

      let(:resource) { subject.bundled_data.data }

      it { is_expected.to be_a_success }

      it 'builds valid resource' do
        expect(resource).to be_a(Resource)
      end
    end
  end
end
