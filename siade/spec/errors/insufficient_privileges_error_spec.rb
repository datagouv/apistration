RSpec.describe InsufficientPrivilegesError, type: :error do
  it_behaves_like 'a valid error' do
    subject { described_class.new('api_entreprise') }
  end
end
