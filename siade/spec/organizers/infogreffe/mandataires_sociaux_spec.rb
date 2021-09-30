RSpec.describe Infogreffe::MandatairesSociaux, type: :retriever_organizer do
  describe '.call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        siren: siren
      }
    end

    context 'with valid siren', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
      let(:siren) { valid_siren(:extrait_rcs) }

      it { is_expected.to be_a_success }

      its(:resource_collection) { is_expected.to be_present }
    end

    context 'with invalid siren', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_siren_not_found' } do
      let(:siren) { not_found_siren(:extrait_rcs) }

      it { is_expected.to be_a_failure }
    end
  end
end
