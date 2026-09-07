require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Foyer RSA with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/foyer_rsa/identite' do
    get "[Identité] #{SwaggerData.get('cnav.foyer_rsa.title')}" do
      tags(*SwaggerData.get('cnav.foyer_rsa.tags'))

      common_action_attributes

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseeCommuneNaissance
          codeCogInseePaysNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseePaysNaissance
        ]
      )

      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[jean charlie] }
      let(:anneeDateNaissance) { 2008 }
      let(:moisDateNaissance) { 1 }
      let(:jourDateNaissance) { 1 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:sexeEtatCivil) { 'M' }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(CNAV::FoyerRSA)

      let(:scopes) { %i[cnav_foyer_rsa] }

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Foyer trouvé' do
          description SwaggerData.get('cnav.foyer_rsa.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('cnav.foyer_rsa.attributes')
          )

          run_test!
        end

        describe 'when not found' do
          let(:nomNaissance) { 'Lefebvre' }
          let(:'prenoms[]') { %w[claire] }

          response '404', 'Non trouvé' do
            build_rswag_example(NotFoundError.new('CNAV'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          unprocessable_content_error_request(:sexe_etat_civil) do
            let(:sexeEtatCivil) { 'lol' }
          end

          common_provider_errors_request('CNAV', CNAV::FoyerRSA)

          common_network_error_request('CNAV', CNAV::FoyerRSA)
        end
      end
    end
  end
end
