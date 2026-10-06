require 'rails_helper'

RSpec.describe 'POST /auth/proconnect_api_*' do
  %w[entreprise particulier].each do |type|
    context "when on API #{type.capitalize}" do
      subject(:authorization_uri) do
        post "/auth/proconnect_api_#{type}"

        URI(response.location.to_s)
      end

      before { host! "#{type}.api.localtest.me" }

      it 'redirects to the ProConnect authorization endpoint' do
        expect(authorization_uri.to_s).to start_with('https://proconnect.test/authorize?')
      end

      it 'requires a MFA acr as an essential claim of the id_token' do
        claims = Rack::Utils.parse_query(authorization_uri.query)['claims']

        expect(JSON.parse(claims)).to eq(
          'id_token' => {
            'acr' => {
              'essential' => true,
              'values' => %w[eidas0-mfa eidas1-mfa eidas2 eidas3]
            }
          }
        )
      end
    end
  end
end
