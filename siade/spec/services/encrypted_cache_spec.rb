require 'rails_helper'

RSpec.describe EncryptedCache, type: :service do
  describe '.read' do
    subject(:cached_value) { described_class.read(key) }

    let(:hashed_key) { Digest::SHA256.hexdigest("#{salt_key}:#{key}") }
    let(:salt_key) { Siade.credentials[:encrypted_cache_salt_key] }
    let(:key) { 'whatever' }

    context 'without value set' do
      before do
        Rails.cache.clear
      end

      it { is_expected.to be_nil }
    end

    context 'with a value set' do
      let(:value) { Siren.new(valid_siren) }

      before do
        described_class.write(key, value)
      end

      it { is_expected.to be_a(Siren) }
      it { expect(cached_value.siren).to eq(valid_siren) }

      it 'sets value in Rails cache with a hashed key' do
        expect(Rails.cache.read(hashed_key)).to be_present
      end
    end

    context 'with invalid string value set' do
      before do
        Rails.cache.write(hashed_key, 'lol')
      end

      it { is_expected.to be_nil }

      it 'cleans invalid value in cache' do
        expect {
          cached_value
        }.to change { Rails.cache.read(hashed_key) }.to(nil)
      end
    end

    context 'with invalid value set (non-string object)' do
      before do
        Rails.cache.write(hashed_key, Siren.new(valid_siren))
      end

      it { is_expected.to be_nil }

      it 'cleans invalid value in cache' do
        expect {
          cached_value
        }.to change { Rails.cache.read(hashed_key) }.to(nil)
      end
    end
  end

  describe '.write' do
    subject { described_class.write(key, value, options) }

    let(:key) { 'key' }
    let(:value) { 'value' }
    let(:options) { { expires_in: 9001 } }

    let(:redis_error) do
      Redis::CommandError.new('ERR invalid expire time in set')
    end

    context 'when redis raises an error' do
      before do
        allow(Rails.cache).to receive(:write).and_raise(redis_error)
      end

      it 'does not raise error' do
        expect {
          subject
        }.not_to raise_error
      end

      it 'tracks error with key and option (not value, which can be sensitive)' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          :warn,
          'EncryptedCache redis error',
          {
            exception_message: redis_error.message,
            params: {
              key:,
              options:
            }
          }
        )

        subject
      end
    end
  end

  describe '.expires_in' do
    subject { described_class.expires_in(key) }

    let(:key) { 'key' }

    context 'when key does not exist' do
      it { is_expected.to be_nil }
    end

    context 'when key exists but has no expiration sets' do
      before do
        described_class.write(key, 'whatever')
      end

      it { is_expected.to be_nil }
    end

    context 'when key exists and has an expiration sets' do
      before do
        described_class.write(key, 'whatever', expires_in: 9001)
        byebug
      end

      it { is_expected.to be_within(10).of(9000) }
    end
  end
end
