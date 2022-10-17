RSpec.describe EuropeanCommission::VIES::BuildResource, type: :build_resource do
  subject(:organizer) { described_class.call(tva_number:) }

  let(:tva_number) { danone_tva_number }

  describe 'resource' do
    subject { organizer.bundled_data.data }

    it { is_expected.to be_a(Resource) }
    its(:tva_number) { is_expected.to eq(tva_number) }
  end
end
