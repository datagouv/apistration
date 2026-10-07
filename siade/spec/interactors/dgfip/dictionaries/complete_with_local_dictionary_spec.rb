RSpec.describe DGFIP::Dictionaries::CompleteWithLocalDictionary, type: :interactor do
  subject(:dictionary) { described_class.call(params: { year: }, bundled_data:).bundled_data.data.dictionnaire }

  let(:year) { 2042 }
  let(:local_file_path) { Rails.root.join('config', 'dgfip', 'dictionnaires', "#{year}.json") }
  let(:bundled_data) { BundledData.new(data: Resource.new(dictionnaire: remote_dictionary), context: {}) }

  let(:remote_dictionary) do
    [
      imprime('2050', [declaration('300263', 'Remote AA'), declaration('914984', 'Remote F1')]),
      { 'numero_imprime' => '2052', 'millesimes' => nil }
    ]
  end

  let(:local_dictionary) do
    [
      imprime('2050', [declaration('300263', 'Local AA'), declaration('905900', 'Local only')]),
      imprime('2052', [declaration('913111', 'Local 2052')]),
      imprime('2059F', [declaration('905901', 'Local 2059F')])
    ]
  end

  def imprime(numero_imprime, declarations)
    { 'numero_imprime' => numero_imprime, 'millesimes' => { 'millesime' => 202_501, 'declaration' => declarations } }
  end

  def declaration(code_nref, intitule)
    { 'code_nref' => code_nref, 'intitule' => intitule }
  end

  def declarations_of(numero_imprime)
    dictionary.find { |entry| entry['numero_imprime'] == numero_imprime }.dig('millesimes', 'declaration')
  end

  context 'when a local dictionary exists for the year' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with(local_file_path).and_return(true)
      allow(File).to receive(:read).and_call_original
      allow(File).to receive(:read).with(local_file_path).and_return({ dictionnaire: local_dictionary }.to_json)
    end

    it 'keeps remote declarations and appends local ones missing remotely' do
      expect(declarations_of('2050')).to eq([
        declaration('300263', 'Remote AA'),
        declaration('914984', 'Remote F1'),
        declaration('905900', 'Local only')
      ])
    end

    it 'uses the local imprime when the remote one has no millesimes' do
      expect(declarations_of('2052')).to eq([declaration('913111', 'Local 2052')])
    end

    it 'appends local imprimes missing remotely' do
      expect(declarations_of('2059F')).to eq([declaration('905901', 'Local 2059F')])
    end
  end

  context 'when there is no local dictionary for the year' do
    it 'keeps the remote dictionary' do
      expect(dictionary).to eq(remote_dictionary)
    end
  end
end
