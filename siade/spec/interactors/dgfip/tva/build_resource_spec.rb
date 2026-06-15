RSpec.describe DGFIP::TVA::BuildResource, type: :build_resource do
  subject(:result) { described_class.call(tva_number:, date_derniere_mise_a_jour:) }

  let(:tva_number) { 'FR72217500016' }
  let(:date_derniere_mise_a_jour) { '2026-06-11' }

  it { is_expected.to be_a_success }

  describe 'resource' do
    subject { result.bundled_data.data }

    it { is_expected.to be_a(Resource) }
    its(:numero_tva) { is_expected.to eq('FR72217500016') }
    its(:date_derniere_mise_a_jour) { is_expected.to eq('2026-06-11') }
  end
end
