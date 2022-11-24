RSpec.describe BlacklistedTokenError, type: :error do
  it_behaves_like 'a valid error' do
    subject { described_class.new('entreprise') }
  end
end
