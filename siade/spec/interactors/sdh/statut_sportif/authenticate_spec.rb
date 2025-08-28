RSpec.describe SDH::StatutSportif::Authenticate do
  subject(:interactor) { described_class.call }

  before do
    stub_sdh_authenticate
  end

  it { is_expected.to be_a_success }

  its(:token) { is_expected.to eq('super_sdh_access_token') }
end
