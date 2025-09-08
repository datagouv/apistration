require 'rails_helper'

RSpec.describe StringNormalizer do
  let(:dummy_class) do
    Class.new do
      include StringNormalizer

      def normalize_public(value)
        normalize_string(value)
      end
    end
  end

  let(:instance) { dummy_class.new }

  describe '#normalize_string' do
    it 'returns nil for nil input' do
      expect(instance.normalize_public(nil)).to be_nil
    end

    it 'converts to uppercase and removes accents' do
      expect(instance.normalize_public('Jean-François')).to eq('JEAN FRANCOIS')
    end

    it 'replaces punctuation with spaces and prevents consecutive spaces' do
      expect(instance.normalize_public('O\'Connor--Smith')).to eq('O CONNOR SMITH')
    end

    it 'trims whitespace' do
      expect(instance.normalize_public('  María José  ')).to eq('MARIA JOSE')
    end

    it 'filters non-ASCII characters' do
      expect(instance.normalize_public('Test€Symbol™')).to eq('TESTSYMBOL')
    end

    it 'handles complex normalization' do
      expect(instance.normalize_public('  Åse Bjørn-Håkan™  ')).to eq('ASE BJORN HAKAN')
    end
  end
end
