require 'swagger_helper'

RSpec.describe 'DSNJ: Service National With Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dsnj/service_national/identite' do
    get "[Identité] #{SwaggerData.get('dsnj.service_national.title')}" do
      tags(*SwaggerData.get('dsnj.service_national.tags'))

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
      let(:'prenoms[]') { %w[Jean Charlie] }
      let(:anneeDateNaissance) { 2000 }
      let(:moisDateNaissance) { 1 }
      let(:jourDateNaissance) { 1 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:sexeEtatCivil) { 'M' }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(DSNJ::ServiceNational)

      let(:scopes) { %i[dsnj_service_national] }

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Identité trouvée', vcr: { cassette_name: 'dsnj/valid' }, pending: 'Implement endpoint' do
          description SwaggerData.get('dsnj.service_national.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('dsnj.service_national.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          unprocessable_entity_error_request(:sexe_etat_civil) do
            let(:sexeEtatCivil) { 'lol' }
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'dsnj/not_found' }, pending: 'Implement endpoint' do
            let(:nom_naissance) { 'UNKNOWN' }

            build_rswag_example(NotFoundError.new('DSNJ'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('DSNJ', DSNJ::ServiceNational)

          common_network_error_request('DSNJ', DSNJ::ServiceNational)
        end
      end
    end
  end
end
