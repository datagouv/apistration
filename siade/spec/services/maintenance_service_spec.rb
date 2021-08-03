require 'rails_helper'

RSpec.describe MaintenanceService, type: :service do
  let(:instance) { described_class.new(provider) }

  describe 'on?' do
    subject { instance.on? }

    context 'with invalid provider' do
      let(:provider) { 'whaveter' }

      it { is_expected.to eq false }
    end

    context 'with valid provider' do
      let(:provider) { 'dgfip' }

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
        before do
          Timecop.freeze(beginning_of_day + 1.hour + 10.minutes)
        end

        it { is_expected.to eq true }
      end
    end
  end
end
