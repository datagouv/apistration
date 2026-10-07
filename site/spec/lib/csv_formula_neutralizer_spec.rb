RSpec.describe CsvFormulaNeutralizer do
  describe '.call' do
    ['=SUM(A1)', '+33612345678', '-2+3', '@SUM(A1)', "\tcmd", "\rcmd"].each do |value|
      it "prefixes #{value.inspect} with an apostrophe" do
        expect(described_class.call(value)).to eq("'#{value}")
      end
    end

    it 'keeps harmless strings untouched' do
      expect(described_class.call('Intitulé = test')).to eq('Intitulé = test')
    end

    it 'keeps numbers untouched, even negative ones' do
      expect(described_class.call(-3)).to eq(-3)
    end

    it 'keeps nil untouched' do
      expect(described_class.call(nil)).to be_nil
    end
  end

  describe '.write_converters' do
    it 'neutralizes formulas through CSV.generate' do
      csv = CSV.generate(write_converters: described_class.write_converters) { |rows| rows << ['=1+1', -3, nil] }

      expect(csv).to eq("'=1+1,-3,\n")
    end
  end
end
