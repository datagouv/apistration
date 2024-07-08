require 'swagger_helper'

RSpec.describe 'INPI: Bilansdownload', api: :entreprise, type: %i[request swagger] do
  path '/v3/inpi/rne/unites_legales/open_data/bilans/{document_id}' do
    get SwaggerData.get('inpi_rne.bilans_download.title') do
      tags(*SwaggerData.get('inpi_rne.bilans_download.tags'))

      common_action_attributes

      parameter name: :document_id, in: :path, type: :string

      unauthorized_request do
        let(:document_id) { valid_rne_document_id }
      end

      forbidden_request do
        let(:document_id) { valid_rne_document_id }
      end

      too_many_requests(INPI::RNE::BilansDownload) do
        let(:document_id) { valid_rne_document_id }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'inpi/rne/bilans_download/valid' } do
          let(:document_id) { '63e7e2e7998acaecf81b486f' }

          description SwaggerData.get('inpi_rne.bilans_download.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('inpi_rne.bilans_download.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:document_id) { valid_rne_document_id }

          unprocessable_entity_error_request(:siren) do
            let(:document_id) { 'lol' }
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'inpi/rne/bilans_download/not_found' } do
            let(:document_id) { not_found_rne_document_id }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INPI - RNE', INPI::RNE::BilansDownload)

          common_network_error_request('INPI - RNE', INPI::RNE::BilansDownload)
        end
      end
    end
  end
end
