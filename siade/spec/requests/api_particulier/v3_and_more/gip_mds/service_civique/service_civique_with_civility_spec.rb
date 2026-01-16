require 'swagger_helper'

RSpec.describe 'GIPMDS: Servicecivique With Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/gip_mds/service_civique/identite' do
    get "[Identité] #{SwaggerData.get('gip_mds.service_civique.title')}" do
      tags(*SwaggerData.get('gip_mds.service_civique.tags'))

      common_action_attributes

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
        ]
      )

      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[jean charlie] }
      let(:anneeDateNaissance) { 2008 }
      let(:moisDateNaissance) { 1 }
      let(:jourDateNaissance) { 1 }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(GIPMDS::ServiceCivique)

      let(:scopes) { %i[gip_mds_service_civique] }

      describe 'with valid token and mandatory params', :valid do
        describe 'when found' do
          before { stub_gip_mds_service_civique_valid }

          response '200', 'Identité trouvée' do
            description SwaggerData.get('gip_mds.service_civique.description')

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('gip_mds.service_civique.attributes')
            )

            run_test!
          end
        end

        describe 'when not found' do
          before { stub_gip_mds_service_civique_not_found }

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('GIP-MDS'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'when too many individuals match' do
          before { stub_gip_mds_service_civique_too_many_individus }

          response '422', 'Entité non traitable' do
            build_rswag_example(UnprocessableEntityError.new(:gip_mds_too_many_individus))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          common_provider_errors_request('GIP-MDS', GIPMDS::ServiceCivique)

          common_network_error_request('GIP-MDS', GIPMDS::ServiceCivique)
        end
      end
    end
  end
end
