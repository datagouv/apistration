require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Foyer RSA with FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/foyer_rsa/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('cnav.foyer_rsa.title')}" do
      tags(*SwaggerData.get('cnav.foyer_rsa.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[cnav_foyer_rsa] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          # The default FranceConnect test identity carries a rolling birthdate
          # ("current year - 20"), so it cannot be matched by a static mock payload
          # file: force a miss so the 200 case below stays testable as pending.
          allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
        end

        # Left pending until this endpoint graduates out of prochainement mode
        # (real ValidateResponse/BuildResource against a real provider call).
        response '200', 'Foyer trouvé', pending: 'Implement endpoint' do
          description SwaggerData.get('cnav.foyer_rsa.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('cnav.foyer_rsa.attributes')
          )

          run_test!
        end

        describe 'when identite is not found' do
          response '404', 'Non trouvé' do
            build_rswag_example(NotFoundError.new('CNAV'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end
      end
    end
  end
end
