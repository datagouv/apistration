RSpec.describe DGFIP::AttestationFiscale::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(url: 'not.a.real/file/upload', params:) }

    let(:params) do
      {
        siren: valid_siren
      }
    end

    it { is_expected.to be_success }

    it 'builds valid resource' do
      resource = subject.payload_data.data

      expect(resource).to be_a(Resource)

      expect(resource.to_h).to include(
        document_url: 'not.a.real/file/upload'
      )
    end
  end
end
