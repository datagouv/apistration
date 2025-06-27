RSpec.describe INPI::RNE::ExtraitDownload, type: :retriever_organizer do
  describe '.call', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    subject { described_class.call(params:) }

    let(:siren) { valid_siren }

    let(:params) do
      {
        siren:
      }
    end

    before { stub_inpi_rne_extrait_download_valid(document_id: siren) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present

      expect(resource).to be_a(Resource)
    end
  end
end
