RSpec.describe API::V2::DocumentsAssociationsController, type: :controller do
  let(:token) { yes_jwt }

  it_behaves_like 'unauthorized', :show, id: valid_rna_id
  it_behaves_like 'forbidden', :show, id: valid_rna_id
  it_behaves_like 'ask_for_mandatory_parameters', :show, id: valid_rna_id

  describe 'invalid rna association' do
    subject do
      get :show, params: { id: id, token: token }.merge(mandatory_params)
    end

    let(:id) { '11111111111111' }

    its(:status) { is_expected.to eq(422) }

    it 'returns 422 with error message' do
      json = JSON.parse(subject.body)
      expect(json).to have_json_error(detail: 'Le numéro de siret ou le numéro d\'association indiqué n\'est pas correctement formatté')
    end
  end

  shared_examples 'logs_http_code' do |http_code|
    it 'logs provider HTTP Code' do
      expect(ProviderResponseSpy).to receive(:log_http_code).with(provider_name: 'RNA', http_code: http_code)
      get :show, params: { token: token, id: id }.merge(mandatory_params)
    end
  end

  describe 'provider returns an error', vcr: { cassette_name: 'non_regenerable/documents_associations_croix_rouge_error' } do
    subject do
      get :show, params: { id: id, token: token }.merge(mandatory_params)
    end

    let(:id) { '77567227221138' }

    # it's a 200 with an error in documents URLs catched by us !
    it_behaves_like 'logs_http_code', '200'

    its(:status) { is_expected.to eq(502) }

    it 'returns an error message' do
      json = JSON.parse(subject.body)

      expect(json).to have_json_error(detail: 'Mauvaise réponse envoyée par le fournisseur de données')
    end
  end

  describe 'happy path' do
    subject do
      get :show, params: { id: id, token: token }.merge(mandatory_params)
    end

    context 'when there is no documents', vcr: { cassette_name: 'non_regenerable/rna_association/78441274400053_no_doc' } do
      let(:id) { '78441274400053' }
      let(:json) { JSON.parse(subject.body) }

      it_behaves_like 'logs_http_code', '200'

      its(:status) { is_expected.to eq 200 }

      it 'nombre_documents' do
        expect(json['nombre_documents']).to eq 0
      end

      it 'documents' do
        expect(json['documents']).to be_a_kind_of(Array)
        expect(json['documents'].size).to eq 0
      end
    end

    # Prévention routière
    # 77571979202585

    # TODO: regenerate cassette when data is back !
    context 'when using a siret', vcr: { cassette_name: 'rna_association/77571979202585' } do
      context 'when siret is correct' do
        context 'when siret is found' do
          subject { @documents_associations_with_valid_siret }

          let(:id) { '77571979202585' }

          before do
            stub_request(:get, %r{jeunesse-sports\.gouv\.fr/cxf/api/documents/PJ}).to_return(body: open_payload_file('pdf/dummy.pdf'))

            remember_through_each_test_of_current_scope('documents_associations_with_valid_siret') do
              get :show, params: { id: id, token: token }.merge(mandatory_params)
              json = JSON.parse(response.body)
            end
          end

          it 'returns 200' do
            expect(response).to have_http_status(:ok)
          end

          its(['nombre_documents'])            { is_expected.to eq(3) }
          its(['nombre_documents_deficients']) { is_expected.to eq(0) }

          its(['documents']) { is_expected.to be_a_kind_of(Array) }
          its(['documents']) { is_expected.to have(3).items }

          context 'document sample' do
            subject { super()['documents'][0] }

            its(['type']) { is_expected.to eq('Arrêté') }
            its(['url'])  { is_expected.to match(/document_asso/) }
            its(:keys) { are_expected.to include('timestamp') }
          end
        end

        context 'when id is not found', vcr: { cassette_name: 'rna_association/W000000000' } do
          subject do
            get :show, params: { id: id, token: token }.merge(mandatory_params)
          end

          let(:id) { 'W000000000' }

          it_behaves_like 'logs_http_code', '404'

          its(:status) { is_expected.to eq(404) }
        end
      end

      context 'when siret is not valid', vcr: { cassette_name: 'rna_association/11111111111111' } do
        let(:id)    { '11111111111111' }

        it { expect(subject.status).to eq(422) }
      end
    end
  end

  describe 'unhappy paths' do
    context 'some document_rna urls are 404', vcr: { cassette_name: 'non_regenerable/rna_association/W262001597_missing_documents' } do
      let(:id) { 'W262001597' }
      let(:response_payload) { JSON.parse(response.body) }
      let(:response) { get :show, params: { id: id, token: token }.merge(mandatory_params) }

      before do
        allow(Rails.logger).to receive(:error)
      end

      it 'still works, but returns partial content' do
        expect(response.status).to eq(206)
      end

      it 'receives 5 documents but returns only the 2 non 404 pdfs' do
        expect(API::V2::DocumentsAssociationsController::DocumentRNA)
          .to receive(:new).exactly(5).times.and_call_original
        expect(Rails.logger).to receive(:error).once.with(/3 documents sont déficients pour l'association W262001597/)

        expect(response_payload['nombre_documents']).to eq(2)
        expect(response_payload['nombre_documents_deficients']).to eq(3)
        expect(response_payload['documents'].size).to eq(2)
      end
    end
  end

  # Cannot modify the cassette manually since it contains encoded PDF...
  # TODO Find another way than VCR to maintain suck edge cases
  # see https://gitlab.com/etalab/api-entreprise/siade/-/issues/50
  describe 'Incidents', :skip do
    context 'Incident january 2018: some documents are not pdf', vcr: { cassette_name: 'non_regenerable/incidents/rna_association/W262001597_not_a_pdf' } do
      let(:id) { 'W262001597' }
      let(:response_payload) { JSON.parse(response.body) }
      let(:response) { get :show, params: { id: id, token: token }.merge(mandatory_params) }

      it 'still works, but returns partial content' do
        expect(response.status).to eq(206)
      end

      it 'receives documents url but its not pdf' do
        expect(API::V2::DocumentsAssociationsController::DocumentRNA)
          .to receive(:new).exactly(5).times.and_call_original
        expect(Rails.logger).to receive(:error).once.with(/5 documents sont déficients pour l'association W262001597/)

        expect(response_payload['nombre_documents']).to eq(0)
        expect(response_payload['nombre_documents_deficients']).to eq(5)
        expect(response_payload['documents'].size).to eq(0)
      end
    end
  end

  describe 'Non regression test' do
    subject do
      get :show, params: { id: id, token: token }.merge(mandatory_params)
    end

    context 'when association retrievers returns a hash instead of an array for asso->documents->document_rna ', vcr: { cassette_name: 'rna_association/no_documents_key_41763950700017' } do
      let(:id) { '41763950700017' }

      its(:status) { is_expected.to eq(200) }
    end
  end
end
