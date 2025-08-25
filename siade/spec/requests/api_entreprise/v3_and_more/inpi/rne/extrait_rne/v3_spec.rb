require 'swagger_helper'

RSpec.describe 'INPI RNE: Extrait RNE', api: :entreprise, type: %i[request swagger] do
  path '/v3/inpi/rne/unites_legales/{siren}/extrait_rne' do
    get SwaggerData.get('inpi_rne.extrait_rne.title') do
      tags(*SwaggerData.get('inpi_rne.extrait_rne.tags'))

      common_action_attributes

      cacheable_request

      parameter_siren

      unauthorized_request do
        let(:siren) { valid_siren }
      end

      forbidden_request do
        let(:siren) { valid_siren }
      end

      too_many_requests(INPI::RNE::ExtraitRNE) do
        let(:siren) { valid_siren }
      end

      describe 'with valid token and mandatory params', :valid, vcr: { cassette_name: 'inpi/rne/authenticate' } do
        describe 'with valid siren' do
          before do
            stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}").and_return(
              status: 200,
              body: read_payload_file('inpi/rne/extrait_rne/valid.json')
            )
          end

          let(:siren) { valid_siren }

          response '200', 'Extrait RNE trouvés' do
            cacheable_response(extra_description: SwaggerData.get('inpi_rne.extrait_rne.cache_duration'))
            description SwaggerData.get('inpi_rne.extrait_rne.description')

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('inpi_rne.extrait_rne.attributes')
            )

            run_test!
          end
        end

        describe 'not found' do
          before do
            stub_request(:get, "#{Siade.credentials[:inpi_rne_url]}/api/companies/#{siren}").and_return(
              status: 404
            )
          end

          response '404', 'Extrait RNE non trouvés' do
            let(:siren) { non_existent_siren }

            build_rswag_example(NotFoundError.new('INPI - RNE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        describe 'server errors' do
          let(:siren) { valid_siren }

          unprocessable_content_error_request(:siren) do
            let(:siren) { 'lol' }
          end

          common_provider_errors_request('INPI - RNE', INPI::RNE::ExtraitRNE)
          common_network_error_request('INPI - RNE', INPI::RNE::ExtraitRNE)
        end
      end
    end
  end
end
