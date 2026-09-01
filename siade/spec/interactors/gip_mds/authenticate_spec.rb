RSpec.describe GIPMDS::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when authentication succeed' do
    before { mock_gip_mds_authenticate }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to be_present }
  end
end
