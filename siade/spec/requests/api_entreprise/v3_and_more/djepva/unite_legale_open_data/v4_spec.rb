require 'swagger_helper'

RSpec.describe 'DJEPVA: Associations v4, open data version', api: :entreprise, type: %i[request swagger] do
  path '/v4/djepva/api-association/associations/open_data/{siren_or_rna}' do
    get SwaggerData.get('mi.v4/unite_legale_open_data.title') do
      tags(*SwaggerData.get('mi.v4/unite_legale_open_data.tags'))

      parameter_siren_or_rna

      common_action_attributes

      unauthorized_request do
        let(:siren_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siren_or_rna) { valid_rna_id }
      end

      too_many_requests(DJEPVA::UniteLegale) do
        let(:siren_or_rna) { valid_rna_id }
      end

      describe 'with valid token and mandatory params', :valid do
        response 200, 'Association trouvée' do
          description SwaggerData.get('mi.v4/unite_legale_open_data.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('mi.v4/unite_legale_open_data.attributes'),
            meta: SwaggerData.get('mi.v4/unite_legale_open_data.meta')
          )

          rate_limit_headers

          before do
            stub_request(:get, /#{Siade.credentials[:mi_domain]}/).to_return(
              status: 200,
              body: File.read(open_payload_file('mi/association-77567227238579.xml'))
            )
          end

          run_test!
        end

        describe 'server errors' do
          let(:siren_or_rna) { valid_rna_id }

          unprocessable_content_error_request(:siren_or_rna)

          response '404', 'Association non trouvée', vcr: { cassette_name: 'mi/associations/with_rna_not_found' } do
            let(:siren_or_rna) { non_existing_rna_id }

            build_rswag_example(NotFoundError.new('DJEPVA'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('DJEPVA', DJEPVA::UniteLegale)
          common_provider_errors_request('DJEPVA', DJEPVA::UniteLegale)
        end
      end
    end
  end
end
