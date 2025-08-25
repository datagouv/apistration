require 'swagger_helper'

RSpec.describe 'OPQIBI: Certificationsingenierie', api: :entreprise, type: %i[request swagger] do
  path '/v3/opqibi/unites_legales/{siren}/certification_ingenierie' do
    get SwaggerData.get('opqibi.certifications_ingenierie.title') do
      tags(*SwaggerData.get('opqibi.certifications_ingenierie.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:opqibi_with_probatoire) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:opqibi_with_probatoire) }
      end

      too_many_requests(OPQIBI::CertificationsIngenierie) do
        let(:siren) { valid_siren(:opqibi_with_probatoire) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'opqibi/certifications_ingenierie/valid_siren' } do
          description SwaggerData.get('opqibi.certifications_ingenierie.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('opqibi.certifications_ingenierie.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:opqibi_with_probatoire) }

          unprocessable_content_error_request(:siren)

          response '404', 'Non trouvée', vcr: { cassette_name: 'opqibi/certifications_ingenierie/not_found_siren' } do
            let(:siren) { not_found_siren }

            build_rswag_example(NotFoundError.new('OPQIBI'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('OPQIBI', OPQIBI::CertificationsIngenierie)
          common_network_error_request('OPQIBI', OPQIBI::CertificationsIngenierie)
        end
      end
    end
  end
end
