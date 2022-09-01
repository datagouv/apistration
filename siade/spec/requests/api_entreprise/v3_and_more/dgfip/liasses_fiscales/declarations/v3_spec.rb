require 'swagger_helper'

RSpec.describe 'DGFIP: Déclarations des liasses Fiscales', type: %i[request swagger], api: :entreprise do
  path '/v3/dgfip/unites_legales/{siren}/liasses_fiscales/{year}' do
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
        response '501', 'Fonctionnalité non implémenté', vcr: { cassette_name: 'dgfip/liasses_fiscales/valid' } do
          description 'Fonctionnalité non implémenté pour le moment. Cette API est encore en travaux: le dictionnaire sera intégré directement dans les liasses pour éviter d’avoir à appeler 2 API comme sur la V.2.'

          rate_limit_headers

          run_test!
        end
      end
    end
  end
end
