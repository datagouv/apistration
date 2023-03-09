RSpec.describe GIPMDS::Authenticate, type: :interactor do
  subject { described_class.call }

  context 'when authentication succeed', vcr: { cassette_name: 'gip_mds/oauth2' } do
    it { is_expected.to be_a_success }

    its(:token) { is_expected.to be_present }
  end
end
