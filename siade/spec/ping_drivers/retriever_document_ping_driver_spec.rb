RSpec.describe RetrieverDocumentPingDriver, type: :ping_driver do
  describe '#perform' do
    subject(:make_ping) { described_class.new(params).perform }

    let(:params) do
      Rails.application.config_for(:pings)[:api_kind][:with_retriever_document][:driver_params]
    end

    let(:piece_url) { 'https://associations.gouv.fr/api/documents/PJ/00000000-0000-0000-0000-000000000001' }
    let(:other_piece_url) { 'https://associations.gouv.fr/api/documents/PJ/00000000-0000-0000-0000-000000000002' }
    let(:recepisse_url) { 'https://associations.gouv.fr/api/documents/RC/00000000-0000-0000-0000-000000000003' }

    let(:listed_documents) do
      [
        { 'url' => piece_url },
        { 'url' => other_piece_url },
        { 'url' => recepisse_url }
      ]
    end

    let(:association_payload) do
      payload = JSON.parse(File.read(open_payload_file('mi/association-77567227238579.json')))
      template = Array.wrap(payload['documents']['document_rna']).first
      documents = listed_documents.map { |document| template.merge(document) }
      payload['documents'].merge!('nbDocRna' => documents.count.to_s, 'document_rna' => documents)
      payload.to_json
    end

    def stub_document(url, **response)
      stub_request(:get, url).to_return(**response)
    end

    context 'when the association has documents of several kinds' do
      before do
        stub_request(:get, /#{Siade.credentials[:mi_domain]}/).to_return(status: 200, body: association_payload)
      end

      context 'when the first document of each kind is downloadable' do
        before do
          stub_document(piece_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
          stub_document(recepisse_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
        end

        it { is_expected.to eq(:ok) }

        it 'downloads only one document per kind' do
          make_ping

          expect(a_request(:get, other_piece_url)).not_to have_been_made
        end
      end

      context 'when the provider still lists an undated document it no longer serves before a dated one' do
        let(:listed_documents) do
          [
            { 'url' => piece_url, 'time' => nil },
            { 'url' => other_piece_url, 'time' => '1604185200' },
            { 'url' => recepisse_url, 'time' => '1604185200' }
          ]
        end

        before do
          stub_document(piece_url, status: 404)
          stub_document(other_piece_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
          stub_document(recepisse_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
        end

        it { is_expected.to eq(:ok) }

        it 'downloads the dated document before the undated one' do
          make_ping

          expect(a_request(:get, piece_url)).not_to have_been_made
        end
      end

      context 'when the provider fails to serve one kind of document' do
        before do
          stub_document(piece_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
          stub_document(recepisse_url, status: 500)
        end

        it { is_expected.to eq(:bad_gateway) }
      end

      context 'when the provider serves an empty document' do
        before do
          stub_document(piece_url, status: 200, body: '')
          stub_document(recepisse_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
        end

        it { is_expected.to eq(:bad_gateway) }
      end

      context 'when the provider is unreachable for a document' do
        before do
          stub_request(:get, piece_url).to_timeout
          stub_document(recepisse_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
        end

        it { is_expected.to eq(:bad_gateway) }
      end

      context 'when the provider drops the connection during a download' do
        before do
          stub_request(:get, piece_url).to_raise(EOFError)
          stub_document(recepisse_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
        end

        it { is_expected.to eq(:bad_gateway) }
      end
    end

    context 'when the provider lists a malformed document url' do
      let(:recepisse_url) { 'https://associations.gouv.fr/api/documents/RC/bad id' }

      before do
        stub_request(:get, /#{Siade.credentials[:mi_domain]}/).to_return(status: 200, body: association_payload)
        stub_document(piece_url, status: 200, body: open_payload_file('pdf/dummy.pdf'))
      end

      it { is_expected.to eq(:bad_gateway) }
    end

    context 'when the documents list cannot be retrieved' do
      before do
        stub_request(:get, /#{Siade.credentials[:mi_domain]}/).to_return(status: 500, body: '')
      end

      it { is_expected.to eq(:bad_gateway) }
    end
  end
end
