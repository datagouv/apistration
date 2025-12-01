require 'swagger_helper'

RSpec.describe 'GIP-MDS: effectifs mensuels établissement', api: :entreprise, type: %i[request swagger] do
  path '/v3/gip_mds/etablissements/{siret}/effectifs_mensuels/{month}/annee/{year}' do
    before do
      Timecop.freeze

      mock_gip_mds_authenticate
    end

    after do
      Timecop.return
    end

    get SwaggerData.get('gip_mds.effectifs_mensuels_etablissement.title') do
      tags(*SwaggerData.get('gip_mds.effectifs_mensuels_etablissement.tags'))

      common_action_attributes

      parameter_siret

      parameter name: :year, in: :path, type: :string
      parameter name: :month, in: :path, type: :string
      parameter({ name: :profondeur, in: :query }.merge(SwaggerData.get('gip_mds.effectifs_mensuels_etablissement.parameters.profondeur')))
      parameter({ name: :nature_effectif, in: :query }.merge(SwaggerData.get('gip_mds.effectifs_mensuels_etablissement.parameters.nature_effectif')))

      let(:year) { '2020' }
      let(:month) { '01' }
      let(:siret) { valid_siret }
      let(:profondeur) { 1 }
      let(:nature_effectif) { nil }

      unauthorized_request do
        let(:siret) { valid_siret }
      end

      forbidden_request do
        let(:siret) { valid_siret }
      end

      too_many_requests(GIPMDS::EffectifsMensuelsEtablissement) do
        let(:siret) { valid_siret }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Effectifs annuels trouvé' do
          before do
            mock_gip_mds_mensuel_effectifs(siret:, year:, month:, depth: profondeur)
          end

          description SwaggerData.get('gip_mds.effectifs_mensuels_etablissement.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('gip_mds.effectifs_mensuels_etablissement.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret }

          unprocessable_content_error_request(:siret) do
            let(:siret) { 'lol' }
          end

          response '404', 'Effectifs non trouvés' do
            let(:siret) { not_found_siret }

            before do
              mock_gip_mds_not_found
            end

            build_rswag_example(NotFoundError.new('GIP-MDS'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('GIP-MDS', GIPMDS::EffectifsMensuelsEtablissement)
          common_network_error_request('GIP-MDS', GIPMDS::EffectifsMensuelsEtablissement)
        end
      end
    end
  end
end
