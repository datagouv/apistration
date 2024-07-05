RSpec.describe INPI::RNE::BilansDownload, type: :retriever_organizer do
  describe '.call', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    subject { described_class.call(params:) }

    let(:document_id) { valid_rne_document_id }

    let(:params) do
      {
        document_id:
      }
    end

    before { stub_inpi_rne_download_valid(target: 'bilans', document_id:) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present

      expect(resource).to be_a(Resource)
    end
  end
end
