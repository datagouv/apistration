RSpec.describe ProxiedFileService, type: :service do
  let(:url) { 'https://www.example.com/document.pdf' }

  describe '.set' do
    subject { described_class.set(url) }

    it 'renders a unique token' do
      expect(subject).to be_a(String)
    end
  end

  describe '.get' do
    subject { described_class.get(token) }

    let(:token) { described_class.set(url) }

    it { is_expected.to eq(url) }
  end
end
