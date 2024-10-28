require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Quotient Familial with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/quotient_familial/identite' do
    get SwaggerData.get('cnav.quotient-familial-v2.title') do
      tags(*SwaggerData.get('cnav.quotient-familial-v2.tags'))

      common_action_attributes

      cacheable_request

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          nomUsage
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseePaysNaissance
          codeCogInseeCommuneNaissance
          nomCommuneNaissance
          codeCogInseeDepartementNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          sexeEtatCivil
          codeCogInseePaysNaissance
        ],
        api: 'cnav'
      )

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:sexeEtatCivil) { 'M' }
      let(:anneeDateNaissance) { 1980 }
      let(:moisDateNaissance) { 6 }
      let(:jourDateNaissance) { 12 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:codeCogInseeCommuneNaissance) { '17300' }
      let(:codeCogInseeDepartementNaissance) { nil }
      let(:nomCommuneNaissance) { nil }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(CNAV::QuotientFamilialV2)

      let(:scopes) { %i[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse] }

      before do
        stub_cnav_authenticate('quotient_familial_v2')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_valid('quotient_familial_v2', siret: '13002526500013')
        end

        describe 'when the quotient familial is found' do
          response '200', 'Quotient Familial active trouvée' do
            description SwaggerData.get('cnav.quotient-familial-v2.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.quotient-familial-v2.cache_duration'))

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.quotient-familial-v2.attributes')
            )

            run_test!
          end
        end

        describe 'when the quotient familial is not found' do
          response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
            let(:codeCogInseePaysNaissance) { '99623' }
            # rubocop:disable RSpec/ContextWording
            context 'Allocataire non identifié' do
              before do
                stub_cnav_404('quotient_familial_v2', nil)
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "L'allocataire que vous cherchez n'a pas été reconnu.", title: 'Allocataire non identifié', with_identifiant_message: false))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé MSA' do
              before do
                stub_cnav_404('quotient_familial_v2', '00171001')
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la MSA.", title: 'Dossier allocataire absent MSA', with_identifiant_message: false, subcode: '004'))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end

            context 'Dossier non trouvé CNAF' do
              before do
                stub_cnav_404('quotient_familial_v2', '00810011')
              end

              build_rswag_example(NotFoundError.new('CNAV & MSA', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", title: 'Dossier allocataire absent CNAF', with_identifiant_message: false, subcode: '005'))

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
