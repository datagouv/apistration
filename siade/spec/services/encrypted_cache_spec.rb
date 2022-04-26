require 'rails_helper'

RSpec.describe EncryptedCache, type: :service do
  describe '.read' do
    subject(:cached_value) { described_class.read(key) }

    let(:key) { 'whatever' }

    context 'without value set' do
      before do
        Rails.cache.delete(key)
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

      it 'sets value in Rails cache' do
        expect(Rails.cache.read(key)).to be_present
      end
    end

    context 'with invalid value set' do
      before do
        Rails.cache.write(key, 'lol')
      end

      it { is_expected.to be_nil }

      it 'cleans invalid value in cache' do
        expect {
          cached_value
        }.to change { Rails.cache.read(key) }.to(nil)
      end
    end
  end
end
