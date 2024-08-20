RSpec.describe APIParticulier::CivilityParameters do
  subject do
    routes.draw { get 'show' => 'api_particulier/v3_and_more/base#index' }

    get :index, params: { nomNaissance:, codeCogInseeCommuneDeNaissance:, codeCogInseeDepartementDeNaissance:, anneeDateDeNaissance:, nomCommuneNaissance:, token: yes_jwt, api_version: 42 }.merge(api_particulier_mandatory_params)
  end

  before(:all) do
    # rubocop:disable Style/ClassAndModuleChildren
    module APIParticulier::DummyResourceSerializer
      class V42 < APIParticulier::V3AndMore::BaseSerializer; end
    end
    # rubocop:enable Style/ClassAndModuleChildren
  end

  controller(APIParticulier::V3AndMore::BaseController) do
    include APIParticulier::CivilityParameters

    def index
      civility_parameters(requireds: %i[nomNaissance codeCogInseeCommuneDeNaissance])
      render json: { data: true }, status: :ok
    end

    def serializer_module
      APIParticulier::DummyResourceSerializer
    end

    def api_kind
      'api_particulier'
    end

    protected

    def transcogage?
      true
    end
  end

  # rubocop:disable RSpec/VariableName
  let(:nomNaissance) { 'Doe' }
  let(:codeCogInseeCommuneDeNaissance) { '12345' }
  let(:codeCogInseeDepartementDeNaissance) { nil }
  let(:anneeDateDeNaissance) { nil }
  let(:nomCommuneNaissance) { nil }

  describe 'GET #index' do
    context 'with all mandatory parameters' do
      it 'returns 200' do
        expect(subject).to have_http_status(:ok)
      end
    end

    context 'with missing mandatory parameters' do
      let(:nomNaissance) { nil }

      it 'returns 400' do
        expect(subject).to have_http_status(:bad_request)
      end
    end

    context 'with missing codeCogInseeCommuneDeNaissance but with transcogage_params', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
      let(:codeCogInseeCommuneDeNaissance) { nil }
      let(:nomCommuneNaissance) { 'Gennevilliers' }
      let(:codeCogInseeDepartementDeNaissance) { '92' }
      let(:anneeDateDeNaissance) { 2000 }

      it 'returns 200' do
        expect(subject).to have_http_status(:ok)
      end
    end

    context 'with missing codeCogInseeCommuneDeNaissance and without transcogage_params', vcr: { cassette_name: 'insee/metadonnees/one_result' } do
      let(:codeCogInseeCommuneDeNaissance) { nil }
      let(:codeCogInseeDepartementDeNaissance) { '92' }
      let(:anneeDateDeNaissance) { 2000 }

      it 'returns 422' do
        expect(subject).to have_http_status(:bad_request)
      end
    end
    # rubocop:enable RSpec/VariableName
  end
end
