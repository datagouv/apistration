RSpec.describe InfogreffeError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new(:temporary_credentials_error) }
  end
end
