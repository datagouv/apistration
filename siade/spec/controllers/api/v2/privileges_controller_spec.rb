RSpec.describe API::V2::PrivilegesController, type: :controller do
  it_behaves_like 'unauthorized'

  describe 'happy path payload with jwt' do
    subject { JSON.parse(response.body) }

    before { get :show, params: { token: token } }

    let(:token) { yes_jwt }

    it 'has 200 code' do
      expect(response).to have_http_status(:ok)
    end

    it 'displays all roles for jwt' do
      expect(subject['privileges']).to contain_exactly(*JwtHelper.values_for_valid_jwt[:roles])
    end
  end
end
