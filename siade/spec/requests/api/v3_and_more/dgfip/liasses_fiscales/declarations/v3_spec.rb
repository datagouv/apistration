require 'swagger_helper'

RSpec.describe 'DGFIP: Déclarations des liasses Fiscales', type: %i[request swagger] do
  path '/v3/dgfip/liasses_fiscales/declarations/{year}/{siren}' do
    get SwaggerData.get('dgfip.liasses_fiscales.declarations.title') do
      tags(*SwaggerData.get('dgfip.liasses_fiscales.declarations.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string
      parameter name: :year, in: :path, type: :integer

      let(:year) { 2017 }

      unauthorized_request do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:liasse_fiscale) }
      end

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
          description SwaggerData.get('dgfip.liasses_fiscales.declarations.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('dgfip.liasses_fiscales.declarations.attributes'),
            meta: SwaggerData.get('dgfip.liasses_fiscales.declarations.meta')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:liasse_fiscale) }

          unprocessable_entity_error_request(:siren)

          common_provider_errors_request(
            'DGFIP',
            DGFIP::LiassesFiscales::Declarations,
            DGFIPPotentialNotFoundError.new
          )

          common_network_error_request('DGFIP', DGFIP::LiassesFiscales::Declarations)
        end
      end
    end
  end
end
