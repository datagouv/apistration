RSpec.describe INPI::RNE::ActesBilans, type: :retriever_organizer do
  subject { described_class.call(params:) }

  let(:params) do
    {
      siren:
    }
  end

  context 'with valid siren', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    let(:siren) { valid_siren(:inpi) }

    before { stub_inpi_rne_actes_bilans_valid(siren:) }

    it { is_expected.to be_a_success }

    it 'retrieves the resource' do
      resource = subject.bundled_data.data

      expect(resource).to be_present

      expect(resource).to be_a(Resource)
    end
  end
end
