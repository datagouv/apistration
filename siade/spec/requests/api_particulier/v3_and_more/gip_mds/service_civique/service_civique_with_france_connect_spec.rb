require 'swagger_helper'

RSpec.describe 'GIPMDS: Servicecivique With FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/gip_mds/service_civique/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('gip_mds.service_civique.title')}" do
      tags(*SwaggerData.get('gip_mds.service_civique.tags'))

      common_action_attributes

      let(:recipient) { valid_siret(:recipient) }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) { %i[gip_mds_service_civique_statut_actuel gip_mds_service_civique_statut_passe gip_mds_service_civique_organisme_accueil gip_mds_service_civique_dates] }

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
        end

        describe 'when identite is found' do
          before do
            stub_gip_mds_service_civique_valid
          end

          response '200', 'Identité trouvée' do
            description SwaggerData.get('gip_mds.service_civique.description')

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('gip_mds.service_civique.attributes')
            )

            run_test!
          end
        end

        describe 'when identite is not found' do
          before do
            stub_gip_mds_service_civique_not_found
          end

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('GIP-MDS'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        # TODO: Waiting FCv2 to be merge to provide error examples
      end
    end
  end
end
