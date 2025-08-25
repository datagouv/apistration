require 'swagger_helper'

RSpec.describe 'Banque de France: Bilans', api: :entreprise, type: %i[request swagger] do
  path '/v3/banque_de_france/unites_legales/{siren}/bilans' do
    get SwaggerData.get('banque_de_france.bilans_entreprise.title') do
      tags(*SwaggerData.get('banque_de_france.bilans_entreprise.tags'))

      common_action_attributes

      cacheable_request

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:bilan_entreprise_bdf) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:bilan_entreprise_bdf) }
      end

      too_many_requests(BanqueDeFrance::BilansEntreprise) do
        let(:siren) { valid_siren(:bilan_entreprise_bdf) }
      end

      describe 'with valid token and mandatory params', :valid do
        describe 'with valid siren' do
          before do
            mock_valid_dgfip_dictionnaire(2020)
            mock_valid_dgfip_dictionnaire(2021)

            mock_valid_banque_de_france
          end

          let(:siren) { valid_siren(:bilan_entreprise_bdf) }

          response '200', 'Entreprise trouvée', vcr: { cassette_name: 'banque_de_france/valid_siren' } do
            cacheable_response(extra_description: SwaggerData.get('banque_de_france.bilans_entreprise.cache_duration'))
            description SwaggerData.get('banque_de_france.bilans_entreprise.description')

            rate_limit_headers

            schema build_rswag_response_collection(
              properties: SwaggerData.get('banque_de_france.bilans_entreprise.attributes'),
              meta: SwaggerData.get('banque_de_france.bilans_entreprise.meta')
            )

            run_test!
          end
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:bilan_entreprise_bdf) }

          unprocessable_content_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'banque_de_france/bilans_entreprises/not_found_siren' } do
            let(:siren) { non_existent_siren }

            build_rswag_example(NotFoundError.new('Banque de France'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('Banque de France', BanqueDeFrance::BilansEntreprise)

          common_network_error_request('Banque de France', BanqueDeFrance::BilansEntreprise)
        end
      end
    end
  end
end
