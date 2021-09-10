RSpec.describe RNM::EntreprisesArtisanales, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siren: siren
      }
    end

    context 'with valid siren', vcr: { cassette_name: 'rnm_cma/valid_siren_json' } do
      let(:siren) { valid_siren(:rnm_cma) }

      it { is_expected.to be_a_success }

      its(:resource) { is_expected.to be_present }
    end
  end
end
