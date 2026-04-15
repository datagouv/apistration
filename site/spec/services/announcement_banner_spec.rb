require 'rails_helper'

RSpec.describe AnnouncementBanner do
  include ActiveSupport::Testing::TimeHelpers

  subject(:banner) { described_class.instance }

  let(:banner_config) do
    {
      start: '2026-04-23 14:00',
      end: '2026-04-23 19:30',
      title: 'Maintenance ProConnect ce soir à 18h',
      description: 'Une opération de maintenance aura lieu ce soir.'
    }
  end

  before do
    banner.instance_variable_set(:@config, nil)
    allow(Rails.application).to receive(:config_for).with(:announcement_banner).and_return(banner_config)
  end

  describe '#active?' do
    subject { banner.active? }

    context 'when current time is within the window' do
      before { travel_to(Time.zone.parse('2026-04-23 16:00')) }

      it { is_expected.to be true }
    end

    context 'when current time is before the window' do
      before { travel_to(Time.zone.parse('2026-04-23 13:59')) }

      it { is_expected.to be false }
    end

    context 'when current time is after the window' do
      before { travel_to(Time.zone.parse('2026-04-23 19:31')) }

      it { is_expected.to be false }
    end

    context 'when start and end are blank' do
      let(:banner_config) { { start: nil, end: nil, title: nil, description: nil } }

      it { is_expected.to be false }
    end
  end

  describe '#title' do
    it { expect(banner.title).to eq('Maintenance ProConnect ce soir à 18h') }
  end

  describe '#description' do
    it { expect(banner.description).to be_present }
  end

  describe 'config/announcement_banner.yml' do
    before do
      banner.instance_variable_set(:@config, nil)
      allow(Rails.application).to receive(:config_for).with(:announcement_banner).and_call_original
    end

    it 'loads without error' do
      expect { banner.active? }.not_to raise_error
    end

    it 'parses start and end as valid chronological times when present' do
      config = Rails.application.config_for(:announcement_banner)

      if config[:start].present?
        expect(banner.start_time).to be_a(Time)
        expect(banner.end_time).to be_a(Time)
        expect(banner.start_time).to be < banner.end_time
      end
    end
  end
end
