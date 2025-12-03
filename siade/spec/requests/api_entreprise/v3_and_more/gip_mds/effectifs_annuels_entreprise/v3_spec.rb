require 'swagger_helper'

RSpec.describe 'GIP-MDS: effectifs annuel unité légale', api: :entreprise, type: %i[request swagger] do
  path '/v3/gip_mds/unites_legales/{siren}/effectifs_annuels/{year}' do
    before do
      Timecop.freeze

      mock_gip_mds_authenticate
    end

    after do
      Timecop.return
    end

    get SwaggerData.get('gip_mds.effectifs_annuels_entreprise.title') do
      tags(*SwaggerData.get('gip_mds.effectifs_annuels_entreprise.tags'))

      common_action_attributes

      parameter_siren
      parameter({ name: :year, in: :path }.merge(SwaggerData.get('gip_mds.effectifs_annuels_entreprise.parameters.year')))
      parameter({ name: :nature_effectif, in: :query }.merge(SwaggerData.get('gip_mds.effectifs_annuels_entreprise.parameters.nature_effectif')))

      let(:year) { 2020 }
      let(:siren) { valid_siren }
      let(:nature_effectif) { nil }

      unauthorized_request do
        let(:siren) { valid_siren }
      end

      forbidden_request do
        let(:siren) { valid_siren }
      end

      too_many_requests(GIPMDS::EffectifsAnnuelsEntreprise) do
        let(:siren) { valid_siren }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Effectifs annuels trouvé' do
          let(:siren) { valid_siren }
          let(:year) { 2020 }

          before do
            mock_gip_mds_annuel_effectifs(siren:, year:)
          end

          description SwaggerData.get('gip_mds.effectifs_annuels_entreprise.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('gip_mds.effectifs_annuels_entreprise.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren }

          unprocessable_content_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          response '404', 'Effectifs non trouvés' do
            let(:siren) { not_found_siren }

            before do
              mock_gip_mds_not_found
            end

            build_rswag_example(NotFoundError.new('GIP-MDS'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('GIP-MDS', GIPMDS::EffectifsAnnuelsEntreprise)
          common_network_error_request('GIP-MDS', GIPMDS::EffectifsAnnuelsEntreprise)
        end
      end
    end
  end
end
