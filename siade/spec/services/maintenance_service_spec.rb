RSpec.describe MaintenanceService, type: :service do
  let(:instance) { described_class.new(provider) }
  let(:beginning_of_day) { Time.zone.now.beginning_of_day }

  after do
    Timecop.return
  end

  describe 'on?' do
    subject { instance.on? }

    context 'with invalid provider' do
      let(:provider) { 'whaveter' }

      it { is_expected.to be false }
    end

    context 'with valid provider which has a maintenance window within the same day' do
      let(:provider) { 'provider_which_has_a_window_within_same_day' }

      context 'when it is not a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 12.hours)
        end

        it { is_expected.to be false }
      end

      context 'when it is a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 1.hour + 10.minutes)
        end

        it { is_expected.to be true }
      end
    end

    context 'with valid provider which has a maintenance window once a week' do
      let(:provider) { 'provider_which_has_a_window_every_week' }
      let(:beginning_of_week) { Time.zone.now.beginning_of_week }

      context 'when it is not a maintenance window, the same day' do
        before do
          Timecop.freeze(beginning_of_week + 12.hours)
        end

        it { is_expected.to be false }
      end

      context 'when it is not a maintenance window, another day and valid hour' do
        before do
          Timecop.freeze(beginning_of_week + 1.day + 1.hour + 10.minutes)
        end

        it { is_expected.to be false }
      end

      context 'when it is a maintenance window' do
        before do
          Timecop.freeze(beginning_of_week + 1.hour + 10.minutes)
        end

        it { is_expected.to be true }
      end
    end

    context 'with valid provider which has a maintenance across two day (start hour before end hour)' do
      let(:provider) { 'provider_which_has_a_window_across_two_day' }

      let(:beginning_of_day) { Time.zone.now.beginning_of_day }

      context 'when it is not a maintenance window' do
        before do
          Timecop.freeze(beginning_of_day + 12.hours)
        end

        it { is_expected.to be false }
      end

      context 'when it is a maintenance window' do
        context 'at 11pm' do
          before do
            Timecop.freeze(beginning_of_day + 23.hours + 10.minutes)
          end

          it { is_expected.to be true }
        end

        context 'at 3am' do
          before do
            Timecop.freeze(beginning_of_day + 3.hours)
          end

          it { is_expected.to be true }
        end
      end
    end

    context 'with a valid provider which has specific dates, with maintenance window between 8am and 7pm' do
      let(:provider) { 'provider_which_has_specific_dates' }

      context 'when it is not a valid date' do
        let(:day) { Date.parse('2021-02-14') }

        before do
          Timecop.freeze(day + 12.hours)
        end

        it { is_expected.to be false }
      end

      context 'when it is a valid date (first entry)' do
        let(:day) { Date.parse('2021-01-14') }

        context 'when it is a maintenance window' do
          before do
            Timecop.freeze(day + 12.hours)
          end

          it { is_expected.to be true }
        end

        context 'when it is not a maintenance window' do
          before do
            Timecop.freeze(day + 1.hour)
          end

          it { is_expected.to be false }
        end
      end

      context 'when it is a valid date (second entry)' do
        let(:day) { Date.parse('2021-01-15') }

        context 'when it is a maintenance window' do
          before do
            Timecop.freeze(day + 15.hours)
          end

          it { is_expected.to be true }
        end

        context 'when it is not a maintenance window' do
          before do
            Timecop.freeze(day + 12.hours)
          end

          it { is_expected.to be false }
        end
      end
    end
  end

  describe '#remaining_seconds' do
    subject { instance.remaining_seconds }

    context 'with valid provider which has a maintenance window within the same day (between 1 am and 2 am)' do
      let(:provider) { 'provider_which_has_a_window_within_same_day' }

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

    context 'with valid provider which has a maintenance across two day (start hour before end hour) : from 11pm to 8am' do
      let(:provider) { 'provider_which_has_a_window_across_two_day' }

      let(:beginning_of_day) { Time.zone.now.beginning_of_day }

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
