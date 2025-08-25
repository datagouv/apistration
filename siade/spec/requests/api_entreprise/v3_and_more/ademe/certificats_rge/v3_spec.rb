require 'swagger_helper'

RSpec.describe 'ADEME: Certification RGE', api: :entreprise, type: %i[request swagger] do
  path '/v3/ademe/etablissements/{siret}/certification_rge' do
    get SwaggerData.get('ademe.certificats_rge.title') do
      tags(*SwaggerData.get('ademe.certificats_rge.tags'))

      common_action_attributes

      parameter_siret

      parameter name: :limit,
        in: :query,
        type: :number,
        description: 'Limite le nombre de résultats retournés. Valeur entre 1 et 1000 (Défault 1000)',
        example: 100

      let(:limit) { nil }

      unauthorized_request do
        let(:siret) { valid_siret(:rge_ademe) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:rge_ademe) }
      end

      too_many_requests(ADEME::CertificatsRGE) do
        let(:siret) { valid_siret(:rge_ademe) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret' } do
          description SwaggerData.get('ademe.certificats_rge.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('ademe.certificats_rge.attributes')
          )

          run_test!

          describe 'with optional limit' do
            let(:limit) { 2 }

            response '200', 'Entreprise trouvée', vcr: { cassette_name: 'ademe/certificats_rge/valid_siret_with_limit' } do
              run_test!
            end
          end
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:rge_ademe) }

          unprocessable_content_error_request(%i[siren limit])

          response '404', 'Non trouvée', vcr: { cassette_name: 'ademe/certificats_rge/not_found_siret' } do
            let(:siret) { not_found_siret(:rge_ademe) }

            build_rswag_example(NotFoundError.new('ADEME'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('ADEME', ADEME::CertificatsRGE)
          common_network_error_request('ADEME', ADEME::CertificatsRGE)
        end
      end
    end
  end
end
