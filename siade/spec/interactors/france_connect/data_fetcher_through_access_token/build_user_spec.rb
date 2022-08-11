RSpec.describe FranceConnect::DataFetcherThroughAccessToken::BuildUser, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) { france_connect_checktoken_payload(scopes:).to_json }
    let(:scopes) { %w[mesri_identifiant openid identite_pivot] }

    its(:user) { is_expected.to be_a(JwtUser) }

    it 'gets scopes from access token payload' do
      expect(call.user.scopes).to eq(scopes)
    end
  end
end
