require 'swagger_helper'

RSpec.describe 'FNTP: Carte professionnelle Travaux Publics', type: %i[request swagger] do
  path '/v3/fntp/cartes_professionnelle_travaux_publics/{siren}' do
    get SwaggerInformation.get('fntp.carte_professionnelle_travaux_publics.title') do
      tags(*SwaggerInformation.get('fntp.carte_professionnelle_travaux_publics.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:fntp) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:fntp) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Carte professionnelle trouvée', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/valid_siren' } do
          description SwaggerInformation.get('fntp.carte_professionnelle_travaux_publics.description')

          rate_limit_headers

          schema build_rswag_document_response(
            id: valid_siren(:fntp),
            document_url_properties: SwaggerInformation.get('fntp.carte_professionnelle_travaux_publics.document_url_properties')
          )

          run_test!
        end

        response '404', 'Non trouvée', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/not_found_siren' } do
          let(:siren) { not_found_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
