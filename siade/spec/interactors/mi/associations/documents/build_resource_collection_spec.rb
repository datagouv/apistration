RSpec.describe MI::Associations::Documents::BuildResourceCollection, type: :build_resource do
  describe '.call' do
    subject(:call) { described_class.call(**params) }

    let(:params) do
      {
        total_documents: 3,
        upload_errors: 1,
        uploaded_collection:
        [
          {
            id: 'very_id_1',
            type: 'PIECE',
            annee: '2014',
            sous_type: 'DCR',
            even: '5248133',
            time: '1418807656',
            url: 'https://much.url/doc_1',
            lib_sous_type: 'Décret',
            hosted_url: 'first_url',
            url_expires_in: 1.day.to_i,
            errors: []
          },
          {
            id: 'much_id_2',
            type: 'PIECE',
            annee: '2014',
            sous_type: 'STC',
            even: '5248133',
            time: '1418807674',
            url: 'https://another.url/great',
            lib_sous_type: 'Statuts',
            hosted_url: 'second_url',
            url_expires_in: 2.days.to_i,
            errors: []
          },
          {
            id: 'very_id_3',
            type: 'type_3',
            annee: '2014',
            sous_type: 'STC',
            even: '5248133',
            time: 'timestamp_3',
            url: 'https://another.url/great',
            lib_sous_type: 'type_3',
            hosted_url: nil,
            errors: ['error message']
          }
        ]
      }
    end

    it { is_expected.to be_a_success }

    it 'builds a valid resource collection' do
      expect(call.resource_collection).to all(be_a(Resource))
    end

    it 'has successfully self hosted documents data' do
      expect(call.resource_collection.map(&:to_h)).to include(
        {
          id: 'very_id_1',
          timestamp: '1418807656',
          url: 'first_url',
          type: 'Décret',
          expires_in: 1.day.to_i,
          errors: []
        },
        {
          id: 'much_id_2',
          timestamp: '1418807674',
          url: 'second_url',
          type: 'Statuts',
          expires_in: 2.days.to_i,
          errors: []
        }
      )
    end

    it 'has the documents with errors data' do
      expect(call.resource_collection.map(&:to_h)).to include(
        {
          id: 'very_id_3',
          timestamp: 'timestamp_3',
          url: nil,
          expires_in: nil,
          type: 'type_3',
          errors: ['error message']
        }
      )
    end

    it 'has valid meta' do
      expect(call.meta).to eq({
        nombre_documents: 3,
        nombre_documents_deficients: 1
      })
    end
  end
end
