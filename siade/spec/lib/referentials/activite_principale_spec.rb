require 'rails_helper'

RSpec.describe Referentials::ActivitePrincipale do
  describe '#to_h' do
    context 'with NAF2025 nomenclature' do
      subject(:referential) { described_class.new(code:, nomenclature: 'NAF2025') }

      context 'with valid NAF2025 code' do
        let(:code) { '01.11Y' }

        it 'returns the NAF2025 data' do
          result = referential.to_h

          expect(result[:code]).to eq('01.11Y')
          expect(result[:nomenclature]).to eq('NAF2025')
          expect(result[:libelle]).to eq("Culture de céréales, à l\u2019exception du riz, de légumineuses et de graines oléagineuses")
        end
      end

      context 'with invalid code format' do
        let(:code) { 'invalid' }

        it 'returns non référencé' do
          result = referential.to_h

          expect(result[:code]).to eq('invalid')
          expect(result[:nomenclature]).to eq('NAF2025')
          expect(result[:libelle]).to eq('non référencé')
        end
      end

      context 'with nil code' do
        let(:code) { nil }

        it 'returns non référencé' do
          result = referential.to_h

          expect(result[:code]).to be_nil
          expect(result[:nomenclature]).to eq('NAF2025')
          expect(result[:libelle]).to eq('non référencé')
        end
      end
    end

    context 'with NAFRev2 nomenclature' do
      subject(:referential) { described_class.new(code:, nomenclature: 'NAFRev2') }

      context 'with valid NAFRev2 code' do
        let(:code) { '01.11Z' }

        it 'returns the NAFRev2 data' do
          result = referential.to_h

          expect(result[:code]).to eq('01.11Z')
          expect(result[:nomenclature]).to eq('NAFRev2')
          expect(result[:libelle]).to eq("Culture de céréales (à l'exception du riz), de légumineuses et de graines oléagineuses")
        end
      end

      context 'with invalid code format' do
        let(:code) { 'invalid' }

        it 'returns non référencé with original code' do
          result = referential.to_h

          expect(result[:code]).to eq('invalid')
          expect(result[:nomenclature]).to eq('NAFRev2')
          expect(result[:libelle]).to eq('non référencé')
        end
      end
    end
  end
end
