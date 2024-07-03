RSpec.describe INPI::RNE::ActesDownload::MakeRequest, type: :make_request do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        document_id:
      }
    end

    context 'with a valid id' do
      let(:document_id) { 'valid_id' }

      before { stub_inpi_rne_download_valid(target: 'actes', document_id:) }

      it { is_expected.to be_a_success }

      its(:response) { is_expected.to be_a(Net::HTTPOK) }
    end
  end
end
