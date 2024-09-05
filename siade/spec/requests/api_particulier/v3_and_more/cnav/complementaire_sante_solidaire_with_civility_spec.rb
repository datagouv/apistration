require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: complementaire sante solidaire with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/complementaire_sante_solidaire/civility' do
    get SwaggerData.get('cnav.c2s.title') do
      tags(*SwaggerData.get('cnav.c2s.tags'))

      common_action_attributes

      cacheable_request

      parameters_cnav_identite_pivot(
        params: %w[
          nomUsage
          nomNaissance
          prenoms
          anneeDateDeNaissance
          moisDateDeNaissance
          jourDateDeNaissance
          codeCogInseeCommuneDeNaissance
          codePaysLieuDeNaissance
          sexeEtatCivil
          nomCommuneNaissance
          codeCogInseeDepartementDeNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          sexeEtatCivil
          codePaysLieuDeNaissance
        ]
      )

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:sexeEtatCivil) { 'M' }
      let(:anneeDateDeNaissance) { 1980 }
      let(:moisDateDeNaissance) { 6 }
      let(:jourDateDeNaissance) { 12 }
      let(:codePaysLieuDeNaissance) { '99100' }
      let(:codeCogInseeCommuneDeNaissance) { '17300' }
      let(:codeCogInseeDepartementDeNaissance) { nil }
      let(:nomCommuneNaissance) { nil }

      unauthorized_request

      forbidden_request

      too_many_requests(CNAV::ComplementaireSanteSolidaire)

      let(:scopes) { %i[complementaire_sante_solidaire] }

      before do
        stub_cnav_authenticate('complementaire_sante_solidaire')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('complementaire_sante_solidaire', siret: '13002526500013')
        end

        describe 'when the pa is found' do
          response '200', 'Complementaire Sante Solidaire trouvée' do
            description SwaggerData.get('cnav.c2s.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.c2s.attributes')
            )

            run_test!
          end
        end

        describe 'when the pa is not found' do
          response '404', 'Dossier non trouvé' do
            before do
              stub_cnav_404('complementaire_sante_solidaire')
            end

            let(:codePaysLieuDeNaissance) { '99623' }

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.'))

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::ComplementaireSanteSolidaire)
        common_network_error_request('CNAV', CNAV::ComplementaireSanteSolidaire)
      end
    end
  end
end
