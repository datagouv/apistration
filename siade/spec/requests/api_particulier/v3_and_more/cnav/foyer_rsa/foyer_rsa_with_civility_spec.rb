require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Foyer RSA with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/foyer_rsa/identite' do
    get "[Identité] #{SwaggerData.get('cnav.foyer_rsa.title')}" do
      tags(*SwaggerData.get('cnav.foyer_rsa.tags'))

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
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseePaysNaissance
        ],
        api: 'cnav'
      )

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:anneeDateNaissance) { 1980 }
      let(:moisDateNaissance) { 6 }
      let(:jourDateNaissance) { 12 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:sexeEtatCivil) { 'M' }
      let(:codeCogInseeCommuneNaissance) { '17300' }
      let(:nomCommuneNaissance) { nil }
      let(:codeCogInseeDepartementNaissance) { nil }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(CNAV::FoyerRSA)

      let(:scopes) { %i[cnav_foyer_rsa_beneficiaires cnav_foyer_rsa_personnes_a_charge] }

      before do
        stub_cnav_authenticate('foyer_rsa')
      end

      describe 'with valid token and mandatory params', :valid do
        context 'when found' do
          before { stub_cnav_valid('foyer_rsa', siret: '13002526500013') }

          response '200', 'Foyer trouvé' do
            description SwaggerData.get('cnav.foyer_rsa.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.foyer_rsa.attributes')
            )

            run_test! do |response|
              data = JSON.parse(response.body)['data']

              expect(data['beneficiaires'].first).to include('nom_naissance' => 'DUPONT', 'qualite' => 'allocataire')
              expect(data['personnes_a_charge'].first).to include('prenoms' => 'Clotaire Kevin', 'nom_usage' => nil)
            end
          end
        end

        context 'with mocked data (staging)' do
          before { allow(Rails.env).to receive(:staging?).and_return(true) }

          let(:nomNaissance) { 'Dupont' }
          let(:'prenoms[]') { %w[jean charlie] }
          let(:anneeDateNaissance) { 1980 }
          let(:moisDateNaissance) { 1 }
          let(:jourDateNaissance) { 1 }
          let(:codeCogInseeCommuneNaissance) { nil }

          response '200', 'Foyer trouvé' do
            run_test! do |response|
              expect(JSON.parse(response.body).dig('data', 'beneficiaires', 0, 'prenoms')).to eq('Jean Charlie')
            end
          end
        end

        context 'when not found' do
          before { stub_cnav_404('foyer_rsa', 'CNAF') }

          response '404', 'Dossier non trouvé' do
            build_rswag_example(
              NotFoundError.new('CNAF', "Le dossier allocataire n'a pas été trouvé auprès de la CNAF.", title: 'Dossier allocataire absent CNAF', with_identifiant_message: false)
                .add_meta(origin: 'CNAF')
            )

            schema '$ref' => '#/components/schemas/Error'

            run_test! do |response|
              expect(JSON.parse(response.body).dig('errors', 0, 'code')).to eq('23003')
            end
          end
        end

        context 'when the person has no RSA right' do
          before do
            stub_request(:get, cnav_url('foyer_rsa')).with(query: hash_including({})).to_return(
              status: 404,
              body: { errorCode: '40440', error: 'Absence de droit' }.to_json
            )
          end

          response '404', 'Absence de droit au RSA' do
            build_rswag_example(
              NotFoundError.new('CNAV', "La personne a été identifiée mais aucun droit au revenu de solidarité active n'a été trouvé pour son foyer.", title: 'Absence de droit au RSA', with_identifiant_message: false)
            )

            schema '$ref' => '#/components/schemas/Error'

            run_test! do |response|
              expect(JSON.parse(response.body).dig('errors', 0, 'title')).to eq('Absence de droit au RSA')
            end
          end
        end

        describe 'server errors' do
          unprocessable_content_error_request(:sexe_etat_civil) do
            let(:sexeEtatCivil) { 'lol' }
          end

          common_provider_errors_request(CNAV::FoyerRSA)

          common_network_error_request(CNAV::FoyerRSA)
        end
      end
    end
  end
end
