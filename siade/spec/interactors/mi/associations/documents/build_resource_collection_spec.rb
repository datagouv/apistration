RSpec.describe MI::Associations::Documents::BuildResourceCollection, type: :build_resource do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, body:) }
    let(:body) do
      {
        documents: {
          nbDocRna: 2,
          document_rna: [
            { id: 'very_id_1', type: 'PIECE', annee: 2014, sous_type: 'DCR', even: 5_248_133, time: 1_418_807_656, url: 'https://much.url/doc_1', lib_sous_type: 'Décret' },
            { id: 'much_id_2', type: 'PIECE', annee: 2014, sous_type: 'STC', even: 5_248_133, time: 1_418_807_674, url: 'http://localhost:8181/services/great', lib_sous_type: 'Statuts' }
          ]
        }
      }.to_json
    end

    let(:resource_collection) { call.bundled_data.data }

    it { is_expected.to be_a_success }

    it 'builds a valid resource collection' do
      expect(resource_collection).to all(be_a(Resource))
    end

    it 'has valid data' do
      expect(resource_collection.map(&:to_h)).to eq(
        [
          {
            id: 'very_id_1',
            timestamp: '1418807656',
            url: 'https://much.url/doc_1',
            type: 'Décret',
            expires_in: 1.day.to_i,
            errors: []
          },
          {
            id: 'much_id_2',
            timestamp: '1418807674',
            url: "#{Siade.credentials[:mi_domain]}/apim/api-asso/great",
            type: 'Statuts',
            expires_in: 1.day.to_i,
            errors: []
          }
        ]
      )
    end

    it 'has valid meta' do
      meta = call.bundled_data.context

      expect(meta).to eq({
        nombre_documents: 2,
        nombre_documents_deficients: 0
      })
    end
  end
end
