require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Quotient Familial with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/cnav/quotient_familial/civility' do
    get SwaggerData.get('cnav.quotient-familial-v2.title') do
      tags(*SwaggerData.get('cnav.quotient-familial-v2.tags'))

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

      too_many_requests(CNAV::QuotientFamilialV2)

      let(:scopes) { %i[cnaf_quotient_familial] }

      before do
        stub_cnav_authenticate('quotient_familial_v2')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('quotient_familial_v2', siret: '10000000000008')
        end

        describe 'when the quotient familial is found' do
          response '200', 'Quotient Familial active trouvée' do
            description SwaggerData.get('cnav.quotient-familial-v2.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.quotient-familial-v2.cache_duration'))

            schema build_rswag_response_api_particulier(
              attributes: SwaggerData.get('cnav.quotient-familial-v2.attributes')
            )

            run_test!
          end
        end

        describe 'when the quotient familial is not found' do
          response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
            let(:codePaysLieuDeNaissance) { '99623' }
            # rubocop:disable RSpec/ContextWording
            context 'Allocataire non identifié' do
              before do
                stub_cnav_404('quotient_familial_v2', nil)
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "L'allocataire que vous cherchez n'a pas été reconnu"))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé MSA' do
              before do
                stub_cnav_404('quotient_familial_v2', '00171001')
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la MSA."))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé CNAF' do
              before do
                stub_cnav_404('quotient_familial_v2', '00810011')
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF."))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
            # rubocop:enable RSpec/ContextWording
          end
        end

        common_provider_errors_request('CNAV', CNAV::QuotientFamilialV2)
        common_network_error_request('CNAV', CNAV::QuotientFamilialV2)
      end
    end
  end
end
