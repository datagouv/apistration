RSpec.describe BadFileFromProviderError, type: :error do
  it_behaves_like 'a valid error' do
    let(:instance) { described_class.new('ProBTP', :invalid_url, ['whatever', nil].sample) }
  end

  describe 'when kind is not valid' do
    subject(:instance) { described_class.new('ProBTP', :lol) }

    it 'raises an error' do
      expect {
        instance
      }.to raise_error(KeyError)
    end
  end
end
