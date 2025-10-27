require 'swagger_helper'

RSpec.describe 'ANTS: ExtraitImmatriculationVehicule With FranceConnect', api: :particulier, type: %i[request swagger] do
  path '/v3/ants/extrait_immatriculation_vehicule/france_connect' do
    get "[FranceConnect] #{SwaggerData.get('ants.extrait_immatriculation_vehicule.title')}" do
      tags(*SwaggerData.get('ants.extrait_immatriculation_vehicule.tags'))

      common_action_attributes

      parameter name: :immatriculation,
        in: :query,
        type: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.type'),
        description: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.description'),
        example: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.example'),
        required: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.required')

      let(:recipient) { valid_siret(:recipient) }
      let(:immatriculation) { 'TT-939-WA' }
      let(:Authorization) { 'Bearer super_valid_token' }

      forbidden_france_connect_request

      let(:scopes) do
        %i[
          ants_extrait_immatriculation_vehicule_identite_particulier
          ants_extrait_immatriculation_vehicule_adresse_particulier
          ants_extrait_immatriculation_vehicule_statut_rattachement
          ants_extrait_immatriculation_vehicule_donnees_immatriculation_vehicule
          ants_extrait_immatriculation_vehicule_caracteristiques_techniques_vehicule
        ]
      end

      describe 'with a FranceConnect token' do
        before do
          mock_valid_france_connect_checktoken(scopes:)
          stub_ants_extrait_immatriculation_vehicule_valid
        end

        response '200', 'Identité trouvée' do
          description SwaggerData.get('ants.extrait_immatriculation_vehicule.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('ants.extrait_immatriculation_vehicule.attributes'),
            meta: SwaggerData.get('ants.extrait_immatriculation_vehicule.meta')
          )

          run_test!
        end

        describe 'when not found' do
          before { stub_ants_extrait_immatriculation_vehicule_not_found }

          response '404', 'Immatriculation non trouvée ou identité non trouvée pour cette immatriculation' do
            build_rswag_example(NotFoundError.new('ANTS'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        # TODO: Waiting FCv2 to be merge to provide error examples
      end
    end
  end
end
