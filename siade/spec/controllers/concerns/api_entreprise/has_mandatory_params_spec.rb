RSpec.describe APIEntreprise::HasMandatoryParams do
  controller(ApplicationController) do
    include APIEntreprise::HasMandatoryParams

    def index
      render json: {}, status: :ok
    end
  end

  context 'with incomplete list params' do
    it 'returns 422 when param is missing' do
      get :index, params: { context: 'MPS', recipient: '78951073200017' }
      assert_response :unprocessable_entity
    end

    it 'returns 422 when empty param' do
      get :index, params: { context: 'MPS', recipient: '', object: 'MPS_ID_2' }
      assert_response :unprocessable_entity
    end
  end

  context 'with valid list params' do
    it 'returns 200' do
      get :index, params: { context: 'MPS', recipient: '78951073200017', object: 'MPS_ID_2' }
      assert_response :ok
    end
  end
end
