require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: prime acitivte with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/prime_activite/civility' do
    get SwaggerData.get('cnav.prime_activite.title') do
      tags(*SwaggerData.get('cnav.prime_activite.tags'))

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
          anneeDateDeNaissance
          moisDateDeNaissance
          jourDateDeNaissance
          sexeEtatCivil
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

      too_many_requests(CNAV::PrimeActivite)

      let(:scopes) { %i[prime_activite] }

      before do
        stub_cnav_authenticate('prime_activite')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('prime_activite', siret: '10000000000008')
        end

        describe 'when the pa is found' do
          response '200', 'Prime Activite active trouvée' do
            description SwaggerData.get('cnav.prime_activite.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.prime_activite.attributes')
            )

            run_test!
          end
        end

        describe 'when the pa is not found' do
          response '404', 'Dossier non trouvé' do
            before do
              stub_cnav_404('prime_activite')
            end

            let(:codePaysLieuDeNaissance) { '99623' }

            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.'))

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::PrimeActivite)
        common_network_error_request('CNAV', CNAV::PrimeActivite)
      end
    end
  end
end
