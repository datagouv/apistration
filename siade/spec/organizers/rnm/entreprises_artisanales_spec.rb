RSpec.describe RNM::EntreprisesArtisanales, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with valid siren', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
      let(:siren) { valid_siren(:rnm_cma) }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
