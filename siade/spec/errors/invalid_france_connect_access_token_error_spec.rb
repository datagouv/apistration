RSpec.describe InvalidFranceConnectAccessTokenError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:malformed_token) }
  end
end
