require 'rails_helper'

RSpec.describe OpenBureauDate, type: :service do
  after { Timecop.return }

  describe '#next' do
    subject { described_class.new.next_date.to_s }

    context 'when date is the third thursday of the month' do
      before do
        Timecop.freeze(Date.new(2021, 9, 10))
      end

      let(:next_date) { Date.new(2021, 9, 16) }

      it { is_expected.to eq(next_date.to_s) }
    end

    context 'when date is the first thursday of the month' do
      before do
        Timecop.freeze(Date.new(2021, 9, 1))
      end

      let(:next_date) { Date.new(2021, 9, 2) }

      it { is_expected.to eq(next_date.to_s) }
    end

    context 'when today is open bureau day' do
      context 'when before 11:00' do
        before do
          Timecop.freeze(DateTime.new(2022, 10, 6, 8).in_time_zone('Europe/Paris'))
        end

        let(:today_date) { Date.new(2022, 10, 6) }

        it { is_expected.to eq(today_date.to_s) }
      end

      context 'when after 11:00' do
        before do
          Timecop.freeze(DateTime.new(2022, 10, 6, 12).in_time_zone('Europe/Paris'))
        end

        let(:next_date) { Date.new(2022, 10, 20) }

        it { is_expected.to eq(next_date.to_s) }
      end
    end

    describe 'non-regression tests' do
      context 'when first thursday is on 1st of month, before this date' do
        before do
          Timecop.freeze(Date.new(2022, 11, 30))
        end

        let(:next_date) { Date.new(2022, 12, 1) }

        it { is_expected.to eq(next_date.to_s) }
      end

      context 'when first thursday is on 1st of month, after this date' do
        before do
          Timecop.freeze(Date.new(2022, 12, 2))
        end

        let(:next_date) { Date.new(2022, 12, 15) }

        it { is_expected.to eq(next_date.to_s) }
      end
    end

    describe 'when it is a cancelled date' do
      before do
        Timecop.freeze(Date.new(2022, 12, 8))
        allow(YAML).to receive(:load_file).and_return(['2022-12-15'])
      end

      let(:next_date) { Date.new(2022, 12, 29) }

      it { is_expected.to eq(next_date.to_s) }
    end
  end
end
