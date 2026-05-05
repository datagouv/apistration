# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangelogEntry do
  describe '.all' do
    subject(:entries) { described_class.all }

    it { is_expected.to be_an(Array) }
    it { is_expected.to all(be_a(described_class)) }

    it 'sorts entries by date desc' do
      dates = entries.map(&:date)

      expect(dates).to eq(dates.sort.reverse)
    end
  end

  describe '.for' do
    it 'returns entries scoped to api_entreprise plus both' do
      result = described_class.for(:api_entreprise)

      expect(result.map(&:scope).uniq).to all(be_in(%w[api_entreprise both]))
    end

    it 'returns entries scoped to api_particulier plus both' do
      result = described_class.for(:api_particulier)

      expect(result.map(&:scope).uniq).to all(be_in(%w[api_particulier both]))
    end
  end

  describe '.grouped_by_year_for' do
    it 'groups entries by year, descending' do
      result = described_class.grouped_by_year_for(:api_entreprise)

      expect(result.keys).to eq(result.keys.sort.reverse)
      expect(result.values.flatten).to all(satisfy { |entry| entry.relevant_for?(:api_entreprise) })
    end
  end

  describe '#relevant_for?' do
    it 'matches when scope equals api' do
      entry = described_class.new(scope: 'api_entreprise')

      expect(entry.relevant_for?(:api_entreprise)).to be(true)
      expect(entry.relevant_for?(:api_particulier)).to be(false)
    end

    it 'matches both scopes when scope is both' do
      entry = described_class.new(scope: 'both')

      expect(entry.relevant_for?(:api_entreprise)).to be(true)
      expect(entry.relevant_for?(:api_particulier)).to be(true)
    end
  end

  describe '#validate_scope!' do
    it 'raises on unknown scope' do
      entry = described_class.new(scope: 'unknown', title: 'oops')

      expect { entry.validate_scope! }.to raise_error(ArgumentError, /invalid scope/)
    end
  end
end
