RSpec.describe CIBTP::AttestationsMarchePublic::Authenticate do
  subject(:interactor) { described_class.call }

  context 'when authentication succeed' do
    before { stub_cibtp_authenticate }

    it { is_expected.to be_a_success }

    its(:token) { is_expected.to eq('super_cibtp_access_token') }
  end
end
