RSpec.describe INPI::RNE::Authenticate, type: :interactor do
  subject(:authenticate) { described_class.call }

  context 'when inpi rne authentication succeed', vcr: { cassette_name: 'inpi/rne/authenticate' } do
    it { is_expected.to be_a_success }

    it 'fills context with token' do
      expect(authenticate.token).to be_present
    end
  end
end
