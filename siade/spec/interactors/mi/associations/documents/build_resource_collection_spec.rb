RSpec.describe MI::Associations::Documents::BuildResourceCollection, type: :build_resource do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) { instance_double(Net::HTTPOK, body:) }
    let(:body) do
      '<asso>' \
        '<documents>' \
        '<nbDocRna>' \
        '2' \
        '</nbDocRna>' \
        '<document_rna>' \
        '<id>very_id_1</id>' \
        '<type>PIECE</type>' \
        '<annee>2014</annee>' \
        '<sous_type>DCR</sous_type>' \
        '<even>5248133</even>' \
        '<time>1418807656</time>' \
        '<url>https://much.url/doc_1</url>' \
        '<lib_sous_type>Décret</lib_sous_type>' \
        '</document_rna>' \
        '<document_rna>' \
        '<id>much_id_2</id>' \
        '<type>PIECE</type>' \
        '<annee>2014</annee>' \
        '<sous_type>STC</sous_type>' \
        '<even>5248133</even>' \
        '<time>1418807674</time>' \
        '<url>http://localhost:8181/services/great</url>' \
        '<lib_sous_type>Statuts</lib_sous_type>' \
        '</document_rna>' \
        '</documents>' \
        '</asso>'
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
