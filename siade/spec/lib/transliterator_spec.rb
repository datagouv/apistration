require 'rails_helper'

RSpec.describe Transliterator do
  let(:dummy_class) do
    Class.new do
      include Transliterator

      def transliterate_public(value)
        transliterate(value)
      end
    end
  end

  let(:instance) { dummy_class.new }

  describe '#transliterate' do
    it 'returns nil for nil input' do
      expect(instance.transliterate_public(nil)).to be_nil
    end

    it 'returns ASCII strings unchanged' do
      expect(instance.transliterate_public('DUPONT')).to eq('DUPONT')
    end

    it 'keeps French accented characters transliterated' do
      expect(instance.transliterate_public('Kévin')).to eq('Kevin')
    end

    it 'transliterates non-French Latin characters' do
      expect(instance.transliterate_public('João')).to eq('Joao')
      expect(instance.transliterate_public('Zuriñe')).to eq('Zurine')
      expect(instance.transliterate_public('Núria')).to eq('Nuria')
    end

    it 'preserves hyphens and spaces' do
      expect(instance.transliterate_public('Jean-François Marie')).to eq('Jean-Francois Marie')
    end
  end
end
