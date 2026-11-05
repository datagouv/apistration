require 'rails_helper'

RSpec.describe AuthorizationRequestSecuritySettings do
  it 'has valid factory' do
    expect(build(:authorization_request_security_settings)).to be_valid
  end

  describe 'associations' do
    it { is_expected.to belong_to(:authorization_request) }
  end

  describe 'validations' do
    describe 'rate_limit_per_minute' do
      it 'allows nil' do
        settings = build(:authorization_request_security_settings, rate_limit_per_minute: nil)
        expect(settings).to be_valid
      end

      it 'allows positive integers' do
        settings = build(:authorization_request_security_settings, rate_limit_per_minute: 100)
        expect(settings).to be_valid
      end

      it 'rejects zero' do
        settings = build(:authorization_request_security_settings, rate_limit_per_minute: 0)
        expect(settings).not_to be_valid
        expect(settings.errors[:rate_limit_per_minute]).to be_present
      end

      it 'rejects negative values' do
        settings = build(:authorization_request_security_settings, rate_limit_per_minute: -10)
        expect(settings).not_to be_valid
        expect(settings.errors[:rate_limit_per_minute]).to be_present
      end
    end

    describe 'allowed_ips' do
      it 'allows empty array' do
        settings = build(:authorization_request_security_settings, allowed_ips: [])
        expect(settings).to be_valid
      end

      it 'allows valid IPv4 addresses' do
        settings = build(:authorization_request_security_settings, allowed_ips: ['192.168.1.1', '10.0.0.1'])
        expect(settings).to be_valid
      end

      it 'allows valid IPv4 CIDR notation' do
        settings = build(:authorization_request_security_settings, allowed_ips: ['192.168.1.0/24', '10.0.0.0/8'])
        expect(settings).to be_valid
      end

      it 'allows valid IPv6 addresses' do
        settings = build(:authorization_request_security_settings, allowed_ips: ['2001:db8::1', '::1'])
        expect(settings).to be_valid
      end

      it 'allows valid IPv6 CIDR notation' do
        settings = build(:authorization_request_security_settings, allowed_ips: ['2001:db8::/32'])
        expect(settings).to be_valid
      end

      it 'allows mixed IPv4 and IPv6' do
        settings = build(:authorization_request_security_settings, allowed_ips: ['192.168.1.1', '2001:db8::1'])
        expect(settings).to be_valid
      end

      it 'rejects invalid IP addresses' do
        settings = build(:authorization_request_security_settings, allowed_ips: ['invalid_ip'])
        expect(settings).not_to be_valid
        expect(settings.errors[:allowed_ips]).to include('contains invalid IP or CIDR: invalid_ip')
      end

      it 'rejects invalid CIDR notation' do
        settings = build(:authorization_request_security_settings, allowed_ips: ['192.168.1.0/33'])
        expect(settings).not_to be_valid
        expect(settings.errors[:allowed_ips]).to be_present
      end
    end

    describe 'throttle_overrides' do
      def settings_with(throttle_overrides)
        build(:authorization_request_security_settings, throttle_overrides:)
      end

      it 'allows no override' do
        expect(settings_with({})).to be_valid
      end

      it 'allows a group override carrying its own limit and period' do
        expect(settings_with('gip_mds' => { 'limit' => 100, 'period' => 60 })).to be_valid
      end

      it 'allows an override on a single endpoint throttle' do
        expect(settings_with('api_entreprise_v3_dgfip_attestations_fiscales' => { 'limit' => 10, 'period' => 60 })).to be_valid
      end

      it 'rejects a bare limit, whose period would silently follow the group' do
        expect(settings_with('gip_mds' => 100)).not_to be_valid
      end

      it 'rejects an override without period' do
        expect(settings_with('gip_mds' => { 'limit' => 100 })).not_to be_valid
      end

      it 'rejects an override without limit' do
        expect(settings_with('gip_mds' => { 'period' => 60 })).not_to be_valid
      end

      it 'rejects an override with an unknown key' do
        expect(settings_with('gip_mds' => { 'limit' => 100, 'period' => 60, 'burst' => 10 })).not_to be_valid
      end

      it 'rejects a throttle name absent from throttle.yml' do
        settings = settings_with('unknown_group' => { 'limit' => 100, 'period' => 60 })

        expect(settings).not_to be_valid
        expect(settings.errors[:throttle_overrides]).to include('"unknown_group" is not a throttle of throttle.yml')
      end

      it 'rejects a group name whose throttles are declared per endpoint' do
        expect(settings_with('high_latency_documents' => { 'limit' => 10, 'period' => 60 })).not_to be_valid
      end

      [0, -1, 1.5, 60.0, '60', nil].each do |invalid|
        it "rejects #{invalid.inspect} as limit or period" do
          expect(settings_with('gip_mds' => { 'limit' => invalid, 'period' => 60 })).not_to be_valid
          expect(settings_with('gip_mds' => { 'limit' => 100, 'period' => invalid })).not_to be_valid
        end
      end
    end
  end

  describe 'uniqueness' do
    let!(:authorization_request) { create(:authorization_request) }
    let!(:existing_settings) { create(:authorization_request_security_settings, authorization_request:) }

    it 'does not allow duplicate settings for same authorization_request' do
      duplicate = build(:authorization_request_security_settings, authorization_request:)
      expect { duplicate.save!(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
