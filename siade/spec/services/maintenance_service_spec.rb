require 'rails_helper'

RSpec.describe MaintenanceService, type: :service do
  let(:instance) { described_class.new(provider) }
  let(:beginning_of_day) { Time.zone.now.beginning_of_day }

  describe 'on?' do
    subject { instance.on? }

    context 'with invalid provider' do
      let(:provider) { 'whaveter' }

      it { is_expected.to eq false }
    end

    context 'with valid provider which has a from hour before to hour' do
      let(:provider) { 'normal' }

      after do
        Timecop.return
      end

      context 'when it is not a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 12.hours)
        end

        it { is_expected.to eq false }
      end

      context 'when it is a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 1.hour + 10.minutes)
        end

        it { is_expected.to eq true }
      end
    end

    context 'with valid provider which has a from hour after to hour' do
      let(:provider) { 'from_after_to' }

      let(:beginning_of_day) { Time.zone.now.beginning_of_day }

      after do
        Timecop.return
      end

      context 'when it is not a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 12.hours)
        end

        it { is_expected.to eq false }
      end

      context 'when it is a maintenance window' do
        context 'at 11pm' do
          before do
            Timecop.freeze(beginning_of_day + 23.hours + 10.minutes)
          end

          it { is_expected.to eq true }
        end

        context 'at 3am' do
          before do
            Timecop.freeze(beginning_of_day + 3.hours)
          end

          it { is_expected.to eq true }
        end
      end
    end
  end

  describe '#end_in' do
    subject { instance.end_in }

    context 'with valid provider which has a from hour before to hour' do
      let(:provider) { 'normal' }

      after do
        Timecop.return
      end

      context 'when it is not a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 12.hours)
        end

        it { is_expected.to be_nil }
      end

      context 'when it is a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 1.hour + 10.minutes)
        end

        it { is_expected.to eq 50.minutes.to_i }
      end
    end

    context 'with valid provider which has a from hour after to hour' do
      let(:provider) { 'from_after_to' }

      let(:beginning_of_day) { Time.zone.now.beginning_of_day }

      after do
        Timecop.return
      end

      context 'when it is not a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 12.hours)
        end

        it { is_expected.to be_nil }
      end

      context 'when it is a maintenance window' do
        context 'at 11pm' do
          before do
            Timecop.freeze(beginning_of_day + 23.hours + 10.minutes)
          end

          it { is_expected.to eq (8.hours + 50.minutes).to_i }
        end

        context 'at 3am' do
          before do
            Timecop.freeze(beginning_of_day + 3.hours)
          end

          it { is_expected.to eq 5.hours.to_i }
        end
      end
    end
  end
end
