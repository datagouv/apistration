require 'swagger_helper'

RSpec.describe 'EuropeanCommission: Vies', api: :entreprise, type: %i[request swagger] do
  path '/v3/european_commission/unites_legales/{siren}/numero_tva' do
    get SwaggerData.get('european_commission.vies.title') do
      tags(*SwaggerData.get('european_commission.vies.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { danone_siren }
      end

      too_many_requests(EuropeanCommission::VIES) do
        let(:siren) { danone_siren }
      end

      describe 'with valid token and mandatory params', :valid do
        let(:siren) { danone_siren }

        before do
          stub_request(:get, "#{Siade.credentials[:european_commission_vies_url]}/#{danone_tva_number[2..]}").to_return(
            status: 200,
            body:
          )
        end

        describe 'found response' do
          let(:body) { read_payload_file('vies/valid.json') }

          response '200', 'Numéro de TVA trouvé' do
            description SwaggerData.get('european_commission.vies.description')

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('european_commission.vies.attributes')
            )

            run_test!
          end
        end

        describe 'not found response' do
          let(:body) { read_payload_file('vies/invalid.json') }

          response '404', 'Non trouvée' do
            build_rswag_example(NotFoundError.new('Commission Européenne'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end
      end

      describe 'server errors', :valid do
        unprocessable_content_error_request(:siren) do
          let(:siren) { danone_siren }
        end

        common_provider_errors_request('Commission Européenne', EuropeanCommission::VIES)
        common_network_error_request('Commission Européenne', EuropeanCommission::VIES)
      end
    end
  end
end
