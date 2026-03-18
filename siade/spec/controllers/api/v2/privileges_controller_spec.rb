RSpec.describe API::V2::PrivilegesController, type: :controller do
  it_behaves_like 'unauthorized'

 describe 'happy path payload with jwt' do
   before { get :show, params: {token: token} }

   let(:token) { yes_jwt }

   subject { JSON.parse(response.body) }

   it 'has 200 code' do
     expect(response).to have_http_status(200)
   end

   it 'displays all roles for jwt' do
     expect(subject['privileges']).to contain_exactly(*JwtHelper.values_for_valid_jwt[:roles])
   end
 end
end
