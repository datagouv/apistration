require 'swagger_helper'

RSpec.describe 'INPI::RNE: Actesbilans', api: :entreprise, type: %i[request swagger] do
  path '/v3/inpi/rne/unites_legales/open_data/{siren}/actes_bilans' do
    get SwaggerData.get('inpi_rne.actes_bilans.title') do
      tags(*SwaggerData.get('inpi_rne.actes_bilans.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:inpi) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:inpi) }
      end

      too_many_requests(INPI::RNE::ActesBilans) do
        let(:siren) { valid_siren(:inpi) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée' do
          before do
            stub_inpi_rne_authenticate
            stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}/attachments")
              .to_return(status: 200, body: read_payload_file('inpi/rne/actes_bilans/valid_siren.json'))
          end

          let(:siren) { valid_siren(:inpi) }

          description SwaggerData.get('inpi_rne.actes_bilans.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('inpi_rne.actes_bilans.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:inpi) }

          unprocessable_content_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          response '404', 'Non trouvée' do
            before do
              stub_inpi_rne_authenticate
              stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}/attachments")
                .to_return(status: 404)
            end

            let(:siren) { non_existent_siren }

            build_rswag_example(NotFoundError.new('INPI - RNE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INPI - RNE', INPI::RNE::ActesBilans)

          common_network_error_request('INPI - RNE', INPI::RNE::ActesBilans)
        end
      end
    end
  end
end
