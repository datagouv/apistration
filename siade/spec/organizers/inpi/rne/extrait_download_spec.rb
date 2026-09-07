RSpec.describe INPI::RNE::ExtraitDownload, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:siren) { valid_siren }

    let(:params) do
      {
        siren:
      }
    end

    before do
      stub_inpi_rne_authenticate
      stub_inpi_rne_extrait_download_valid(document_id: siren)
    end

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present

      expect(resource).to be_a(Resource)
    end
  end
end
