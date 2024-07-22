RSpec.describe APIParticulier::V3AndMore::BaseController do
  controller(described_class) do
    def index
      render json: { data: true }, status: :ok
    end

    def api_kind
      'api_particulier'
    end
  end

  describe 'version management' do
    before do
      get :index, params: { api_version:, token: yes_jwt }
    end

    context 'with any version' do
      let(:api_version) { 42 }

      its(:status) { is_expected.to be(200) }
    end
  end
end
