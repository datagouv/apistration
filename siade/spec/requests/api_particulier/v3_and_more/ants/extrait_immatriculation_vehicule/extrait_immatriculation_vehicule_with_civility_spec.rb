require 'swagger_helper'

RSpec.describe 'ANTS: ExtraitImmatriculationVehicule With Civility', api: :particulier, type: %i[request swagger] do
  path '/v3/ants/extrait_immatriculation_vehicule/identite' do
    get "[Identité] #{SwaggerData.get('ants.extrait_immatriculation_vehicule.title')}" do
      tags(*SwaggerData.get('ants.extrait_immatriculation_vehicule.tags'))

      common_action_attributes

      parameter name: :immatriculation,
        in: :query,
        type: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.type'),
        description: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.description'),
        example: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.example'),
        required: SwaggerData.get('ants.extrait_immatriculation_vehicule.parameters.immatriculation.required')

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

      let(:immatriculation) { 'AA-123-AA' }
      let(:nomNaissance) { 'Dupont' }
      let(:'prenoms[]') { %w[jean charlie] }
      let(:anneeDateNaissance) { 2008 }
      let(:moisDateNaissance) { 1 }
      let(:jourDateNaissance) { 1 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:sexeEtatCivil) { 'M' }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(ANTS::ExtraitImmatriculationVehicule)

      let(:scopes) do
        %i[
          ants_extrait_immatriculation_vehicule_identite
          ants_extrait_immatriculation_vehicule_adresse
          ants_extrait_immatriculation_vehicule_statut_rattachement_vehicule
          ants_extrait_immatriculation_vehicule_extrait_immatriculation_vehicule
          ants_extrait_immatriculation_vehicule_extrait_caracteristiques_techniques_vehicule
        ]
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Identité trouvée', pending: 'Implement endpoint' do
          before do
            allow(MockDataBackend).to receive(:get_response_for).and_return(nil)
          end

          description SwaggerData.get('ants.extrait_immatriculation_vehicule.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('ants.extrait_immatriculation_vehicule.attributes')
          )

          run_test!
        end

        describe 'when not found', pending: 'Get not found payload from FD' do
          before { stub_ants_extrait_immatriculation_vehicule_not_found }

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('ANTS'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          unprocessable_entity_error_request(:sexe_etat_civil) do
            let(:sexeEtatCivil) { 'lol' }
          end

          common_provider_errors_request('ANTS', ANTS::ExtraitImmatriculationVehicule)

          common_network_error_request('ANTS', ANTS::ExtraitImmatriculationVehicule)
        end
      end
    end
  end
end
