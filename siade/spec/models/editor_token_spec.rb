RSpec.describe EditorToken do
  describe '#blacklisted?' do
    let(:editor) { Editor.create!(name: 'Test Editor') }

    context 'when blacklisted_at is nil' do
      let(:token) { described_class.create!(editor:, exp: 1.year.from_now.to_i) }

      it 'returns false' do
        expect(token).not_to be_blacklisted
      end
    end

    context 'when blacklisted_at is in the past' do
      let(:token) { described_class.create!(editor:, exp: 1.year.from_now.to_i, blacklisted_at: 1.day.ago) }

      it 'returns true' do
        expect(token).to be_blacklisted
      end
    end

    context 'when blacklisted_at is in the future' do
      let(:token) { described_class.create!(editor:, exp: 1.year.from_now.to_i, blacklisted_at: 1.day.from_now) }

      it 'returns false' do
        expect(token).not_to be_blacklisted
      end
    end
  end
end
