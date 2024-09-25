RSpec.describe APIParticulier::CivilityParameters do
  subject do
    routes.draw { get 'show' => 'api_particulier/v3_and_more/base#index' }

    get :index, params: { nomNaissance:, codeCogInseeCommuneNaissance:, codeCogInseeDepartementNaissance:, anneeDateNaissance:, nomCommuneNaissance:, token: yes_jwt, api_version: 42 }.merge(api_particulier_mandatory_params)
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
      civility_parameters
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
  let(:codeCogInseeCommuneNaissance) { '12345' }
  let(:codeCogInseeDepartementNaissance) { nil }
  let(:anneeDateNaissance) { 1988 }
  let(:nomCommuneNaissance) { nil }

  describe 'GET #index' do
    context 'with parameters' do
      it 'returns 200' do
        expect(subject).to have_http_status(:ok)
      end
    end

    context 'with missing parameters' do
      let(:nomNaissance) { nil }
      let(:codeCogInseeCommuneNaissance) { nil }

      it 'returns 200' do
        expect(subject).to have_http_status(:ok)
      end
    end
    # rubocop:enable RSpec/VariableName
  end
end
