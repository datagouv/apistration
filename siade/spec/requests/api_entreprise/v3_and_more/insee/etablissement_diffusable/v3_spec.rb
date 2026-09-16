require 'swagger_helper'

RSpec.describe 'INSEE: EtablissementDiffusable diffusibbles', api: :entreprise, type: %i[request swagger] do
  path '/v3/insee/sirene/etablissements/diffusibles/{siret}' do
    get SwaggerData.get('insee.etablissement_diffusable.title') do
      tags(*SwaggerData.get('insee.etablissement_diffusable.tags'))

      parameter_siret
      deprecated true

      common_action_attributes

      unauthorized_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      too_many_requests(INSEE::EtablissementDiffusable) do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'EtablissementDiffusable trouvé' do
          before do
            stub_insee_authenticate
            stub_insee_etablissement_active_ge
          end

          description SwaggerData.get('insee.etablissement_diffusable.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.etablissement_diffusable.attributes'),
            links: SwaggerData.get('insee.etablissement.links'),
            meta: SwaggerData.get('insee.etablissement.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret) { sirets_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siret)

          response '404', 'Non trouvé' do
            before do
              stub_insee_authenticate
              stub_insee_etablissement_non_existent
            end

            let(:siret) { non_existent_siret }

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INSEE', INSEE::EtablissementDiffusable)
          common_network_error_request('INSEE', INSEE::EtablissementDiffusable)
        end
      end
    end
  end
end
