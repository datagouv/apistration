require 'swagger_helper'

RSpec.describe 'INSEE: Adresse Etablissement diffusible', api: :entreprise, type: %i[request swagger] do
  path '/v3/insee/sirene/etablissements/diffusibles/{siret}/adresse' do
    get SwaggerData.get('insee.adresse_etablissement_diffusable.title') do
      tags(*SwaggerData.get('insee.adresse_etablissement_diffusable.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      forbidden_request do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      too_many_requests(INSEE::AdresseEtablissementDiffusable) do
        let(:siret) { sirets_insee_v3[:active_GE] }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Etablissement trouvé', vcr: { cassette_name: 'insee/siret/active_GE_with_token' } do
          description SwaggerData.get('insee.adresse_etablissement_diffusable.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('insee.adresse_etablissement_diffusable.attributes'),
            links: SwaggerData.get('insee.adresse_etablissement.links'),
            meta: SwaggerData.get('insee.adresse_etablissement.meta')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { sirets_insee_v3[:active_GE] }

          unprocessable_content_error_request(:siret)

          response '404', 'Non trouvé', vcr: { cassette_name: 'insee/siret/non_existent_with_token' } do
            let(:siret) { non_existent_siret }

            build_rswag_example(NotFoundError.new('INSEE'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('INSEE', INSEE::AdresseEtablissementDiffusable)
          common_network_error_request('INSEE', INSEE::AdresseEtablissementDiffusable)
        end
      end
    end
  end
end
