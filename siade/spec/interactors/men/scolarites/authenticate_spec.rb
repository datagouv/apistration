RSpec.describe MEN::Scolarites::Authenticate do
  subject(:interactor) { described_class.call }

  context 'when authentication succeed' do
    before { stub_men_scolarites_auth }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq('jwt-access-token') }
  end
end
