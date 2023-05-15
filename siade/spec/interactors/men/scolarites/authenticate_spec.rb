RSpec.describe MEN::Scolarites::Authenticate do
  subject(:interactor) { described_class.call }

  context 'when authentication succeed', vcr: { cassette_name: 'men/scolarites/authenticate' } do
    let(:access_token_from_vcr) { 'jwt-access-token' }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq(access_token_from_vcr) }
  end
end
