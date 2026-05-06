RSpec.describe CsvFormatter do
  let(:dummy_class) do
    Class.new(described_class) do
      private

      def i18n_scope = 'dummy.scope'

      def columns
        {
          name: ->(row) { row[:name] },
          age: ->(row) { row[:age] }
        }
      end
    end
  end

  let(:rows) { [{ name: 'Alice', age: 30 }, { name: 'Bob', age: 25 }] }

  before do
    I18n.backend.store_translations(:fr, dummy: { scope: { headers: { name: 'Nom', age: 'Âge' } } })
  end

  describe '#to_csv' do
    subject(:csv) { dummy_class.new(rows).to_csv }

    it 'starts with a UTF-8 BOM' do
      expect(csv).to start_with('﻿')
    end

    it 'uses semicolon-separated translated headers from i18n_scope' do
      expect(csv).to include('Nom;Âge')
    end

    it 'serializes rows in column order' do
      expect(csv).to include('Alice;30')
      expect(csv).to include('Bob;25')
    end
  end

  describe '#filename' do
    it 'derives filename from i18n_scope and current date' do
      allow(Date).to receive(:current).and_return(Date.new(2026, 5, 6))
      expect(dummy_class.new([]).filename).to eq('dummy-scope-2026-05-06.csv')
    end
  end

  describe 'abstract methods' do
    it 'raises NotImplementedError without subclass' do
      expect { described_class.new([]).to_csv }.to raise_error(NotImplementedError)
    end
  end
end
