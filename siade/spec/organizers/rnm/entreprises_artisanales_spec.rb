RSpec.describe RNM::EntreprisesArtisanales, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params:) }

    let(:params) do
      {
        siren:
      }
    end

    context 'with valid siren' do
      let(:siren) { valid_siren(:rnm_cma) }

      before { stub_rnm_valid_siren }

      it { is_expected.to be_a_success }

      it 'retrieves the resource' do
        resource = subject.bundled_data.data

        expect(resource).to be_present
      end
    end
  end
end
