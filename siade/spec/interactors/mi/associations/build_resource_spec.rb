RSpec.describe MI::Associations::BuildResource, type: :build_resource do
  describe '.call' do
    subject { described_class.call(response:, params:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:params) do
      {
        siret_or_rna: valid_rna_id
      }
    end

    describe 'happy path' do
      let(:body) do
        open_payload_file('mi/association-77567227238579.xml').read
      end

      let(:resource) { subject.bundled_data.data }

      it { is_expected.to be_a_success }

      it 'builds valid resource' do
        expect(resource).to be_a(Resource)
      end

      describe 'when there is document dac or rna' do
        let(:regexp_uuid) { /d{8}-\d{4}-\d{4}-\d{4}-\d{12}/ }
        let(:regexp_hashed_uuid) { /\A[a-fA-F0-9]{64}\z/ }

        let(:document_rna_id) { subject.bundled_data.data.documents_rna.first[:id] }
        let(:document_dac_id) { subject.bundled_data.data.etablissements.first[:documents_dac].first[:id] }

        it 'do not return the original ID of documents' do
          expect(document_rna_id).not_to match(regexp_uuid)
          expect(document_dac_id).not_to match(regexp_uuid)
        end

        it 'returns a hashed ID of documents' do
          expect(document_rna_id).to match(regexp_hashed_uuid)
          expect(document_dac_id).to match(regexp_hashed_uuid)
        end
      end

      describe 'documents\'s url' do
        let(:document_url) { subject.bundled_data.data.agrements.first[:url] }

        it 'substitute localhost with valid url' do
          expect(document_url).to eq("#{Siade.credentials[:mi_domain]}/apim/api-asso/documents/00000000-0000-0000-0000-000000000001")
        end
      end
    end

    describe 'when payload has only one dac document (non-regression test)' do
      let(:body) do
        open_payload_file('mi/association-77567227238579-1dac.xml').read
      end

      let(:resource) { subject.bundled_data.data }

      it { is_expected.to be_a_success }

      it 'builds valid resource' do
        expect(resource).to be_a(Resource)
      end
    end
  end
end
