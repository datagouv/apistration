RSpec.describe DGFIP::TVA::BuildTVANumberFromSiren, type: :interactor do
  describe '.call' do
    subject(:result) { described_class.call(params:) }

    let(:params) { { siren: '217500016' } }

    it { is_expected.to be_a_success }

    its(:tva_number) { is_expected.to eq('FR72217500016') }
    its(:tva_number_candidates) { is_expected.to eq(TVAIntracommunautaire.new('217500016').candidates) }
  end
end
