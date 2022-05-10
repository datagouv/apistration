RSpec.describe BadFileFromProviderError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new('ProBTP', :invalid_url, ['whatever', nil].sample) }
  end
end
