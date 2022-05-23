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

  describe 'happy path' do
    subject do
      get :show, params: { id: id, token: token }.merge(mandatory_params)
    end

    context 'when there is no documents', vcr: { cassette_name: 'non_regenerable/rna_association/78441274400053_no_doc' } do
      let(:id) { '78441274400053' }
      let(:json) { JSON.parse(subject.body) }

      its(:status) { is_expected.to eq 404 }
    end

    context 'when using a siret', vcr: { cassette_name: 'mi/associations/documents/with_documents' } do
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

          its(:status) { is_expected.to eq(404) }
        end
      end

      context 'when siret is not valid', vcr: { cassette_name: 'rna_association/11111111111111' } do
        let(:id)    { '11111111111111' }

        it { expect(subject.status).to eq(422) }
      end
    end
  end
end
