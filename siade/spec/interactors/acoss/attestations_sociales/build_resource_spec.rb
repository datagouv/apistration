RSpec.describe ACOSS::AttestationsSociales::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(url:, params:) }

    let(:params) do
      {
        siren: valid_siren(:acoss)
      }
    end
    let(:url) { "not.a.real/file#{rand(999)}/upload" }

    it { is_expected.to be_success }

    it 'builds valid resource' do
      expect(subject.bundled_data.data).to be_a(Resource)

      expect(subject.bundled_data.data.to_h).to include(
        document_url: url
      )
    end
  end
end
