RSpec.describe ACOSS::AttestationsSociales::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(url: url, params: params) }

    let(:params) do
      {
        siren: valid_siren(:acoss),
      }
    end
    let(:url) { "not.a.real/file#{rand(999)}/upload" }

    it { is_expected.to be_success }

    its(:resource) do
      is_expected.to include(
        id: valid_siren(:acoss),
        document_url: url,
      )
    end
  end
end
