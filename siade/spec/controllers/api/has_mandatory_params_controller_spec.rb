RSpec.describe HasMandatoryParams do
  controller(APIController) do
    include HasMandatoryParams

    def index
      render json: {}, status: :ok
    end
  end

  context 'with incomplete list params' do
    it 'returns 422 when param is missing' do
      get :index, params: { context: 'MPS', recipient: '78951073200017' }
      assert_response 422
    end

    it 'returns 422 when empty param' do
      get :index, params: { context: 'MPS', recipient: '', object: 'MPS_ID_2' }
      assert_response 422
    end

    it 'logs' do
      expect(UserAccessSpy).to receive(:log_not_acceptable)
      get :index, params: { context: 'MPS', recipient: '78951073200017', object: '' }
    end
  end

  context 'with valid list params' do
    it 'returns 200' do
      get :index, params: { context: 'MPS', recipient: '78951073200017', object: 'MPS_ID_2' }
      assert_response 200
    end

    it 'does not log as not acceptable' do
      expect(UserAccessSpy).not_to receive(:log_not_acceptable)

      get :index, params: { context: 'MPS', recipient: '78951073200017', object: 'MPS_ID_2' }
    end
  end
end
