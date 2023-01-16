require 'swagger_helper'

RSpec.describe 'MESRI: Scolarite', api: :particulier, type: %i[request swagger] do
  path '/v3/mesri/scolarites/' do
    get SwaggerData.get('mesri.scolarite.title') do
      tags(*SwaggerData.get('mesri.scolarite.tags'))

      common_action_attributes

      parameter name: :nom,                in: :query, type: :string
      parameter name: :prenom,             in: :query, type: :string
      parameter name: :sexe,               in: :query, type: :string
      parameter name: :date_naissance,     in: :query, type: :string
      parameter name: :code_etablissement, in: :query, type: :string
      parameter name: :annee_scolaire,     in: :query, type: :string

      let(:nom) { 'Martin' }
      let(:prenom) { 'Jean' }
      let(:sexe) { '1' }
      let(:date_naissance) { '1980-01-01' }
      let(:code_etablissement) { '1234567A' }
      let(:annee_scolaire) { '2019-2020' }

      unauthorized_request

      forbidden_request

      describe 'with valid token and mandatory params', valid: true do
        response '200', 'Scolarité trouvée', vcr: { cassette_name: 'mesri/valid' } do
          description SwaggerData.get('mesri.scolarite.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('mesri.scolarite.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          unprocessable_entity_error_request(:siren) do
            let(:sexe) { 'whatever' }
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'mesri/not_found' } do
            schema '$ref' => '#/components/schemas/NotFound'

            run_test!
          end

          common_provider_errors_request('MESRI', MESRI::Scolarite)

          common_network_error_request('MESRI', MESRI::Scolarite)
        end
      end
    end
  end
end
