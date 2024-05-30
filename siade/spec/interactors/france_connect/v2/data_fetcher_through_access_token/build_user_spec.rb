RSpec.describe FranceConnect::V2::DataFetcherThroughAccessToken::BuildUser, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) { france_connect_v2_checktoken_payload(scopes:).to_json }
    let(:scopes) { 'mesri_identifiant openid identite_pivot' }

    its(:user) { is_expected.to be_a(JwtUser) }

    it 'gets scopes from access token payload' do
      expect(call.user.scopes).to eq(scopes.split)
    end

    context 'when in staging' do
      before do
        allow(Rails).to receive(:env).and_return('staging'.inquiry)
      end

      it 'provides all API france connect scopes' do
        %w[
          openid identite_pivot
          cnous_statut_boursier
          mesri_identifiant
        ].each do |scope|
          expect(call.user.scopes).to include(scope)
        end
      end
    end
  end
end
