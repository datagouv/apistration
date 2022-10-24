RSpec.describe APIParticulier::IntrospectController do
  subject { get :show, params: { token: } }

  context 'with valid token' do
    let(:token) { TokenFactory.new(scopes).valid }
    let(:scopes) { %w[s1 s2 s3] }

    its(:status) { is_expected.to eq(200) }

    it 'renders payload with ID as _id, name key (empty) and scopes' do
      json_body = JSON.parse(subject.body)

      expect(json_body['_id']).to be_present
      expect(json_body).to have_key('name')
      expect(json_body['scopes']).to eq(scopes)
    end
  end

  context 'with invalid token' do
    let(:token) { 'lol' }

    its(:status) { is_expected.to eq(401) }
  end
end
