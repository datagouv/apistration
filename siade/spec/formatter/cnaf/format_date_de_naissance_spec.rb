RSpec.describe CNAF::FormatDateDeNaissance do
  subject { described_class.new(year, month, day).format }

  describe '#format' do
    let(:year) { '2023' }
    let(:month) { '6' }
    let(:day) { '21' }

    context 'when year and month are not zero' do
      it 'formats the date correctly' do
        expect(subject).to eq('2023-06-21')
      end
    end

    context 'when year is zero' do
      let(:year) { nil }

      it 'formats the date with 0' do
        expect(subject).to eq('0000-00-00')
      end
    end

    context 'when month is zero' do
      let(:month) { nil }

      it 'formats the date with month and day as 0' do
        expect(subject).to eq('2023-00-00')
      end
    end

    context 'when day is zero' do
      let(:day) { nil }

      it 'formats the date with day as 0' do
        expect(subject).to eq('2023-06-00')
      end
    end
  end
end
