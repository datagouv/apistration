RSpec.describe INSEE::AuthenticationBackoff do
  describe '.end_episode!' do
    before { described_class.hold_back_after_refusal! }

    it 'hands the episode over to a single caller when two end it at once' do
      competitors = []
      allow(Rails.cache).to receive(:delete).and_wrap_original do |original, *args, **options|
        competitors << described_class.end_episode! if competitors.push(:racing).one?
        original.call(*args, **options)
      end

      expect([described_class.end_episode!, competitors.last].compact.map(&:refusals)).to eq([1])
    end
  end

  describe '.hold_back_after_refusal!' do
    it 'counts the refusals of the ongoing episode' do
      described_class.hold_back_after_refusal!

      expect(described_class.hold_back_after_refusal!).to eq(2)
    end
  end
end
