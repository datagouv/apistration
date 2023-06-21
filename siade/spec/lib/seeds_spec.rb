RSpec.describe Seeds, type: :lib do
  describe '#perform' do
    subject { described_class.new.perform }

    before do
      Token.delete_all
    end

    it 'works' do
      expect {
        subject
      }.not_to raise_error

      expect(Token.count).to be >= 1
    end
  end
end
