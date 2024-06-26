RSpec.describe APIParticulier::FranceConnectJwksController do
  subject { get :show }

  context 'when response is 200' do
    its(:status) { is_expected.to eq(200) }

    it 'returns a JSON with the jwks' do
      expect(JSON.parse(subject.body)).to have_key('keys')
    end
  end
end
