RSpec.describe FranceConnect::V1::DataFetcherThroughAccessToken::BuildUser, type: :interactor do
  describe '.call' do
    subject(:call) { described_class.call(response:, params: { api_version: }) }

    let(:response) do
      instance_double(Net::HTTPOK, body:)
    end

    let(:body) { france_connect_v1_checktoken_payload(scopes:).to_json }
    let(:scopes) { %w[mesri_identifiant openid identite_pivot api_name_identite] }
    let(:api_version) { '2' }

    its(:user) { is_expected.to be_a(JwtUser) }

    context 'when API version is 3 or more' do
      let(:api_version) { '42' }

      it 'gets scopes from access token payload without api_name_identite' do
        expect(call.user.scopes).to eq(%w[mesri_identifiant openid identite_pivot])
      end
    end

    context 'when API version is 2' do
      it 'gets scopes from access token payload' do
        expect(call.user.scopes).to eq(scopes)
      end
    end

    context 'when in staging' do
      before do
        allow(Rails).to receive(:env).and_return('staging'.inquiry)
      end

      it 'provides all API Particulier scopes' do
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
