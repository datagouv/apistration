require 'swagger_helper'

RSpec.describe 'Qualibat : CertificationsBatiment', type: %i[request swagger] do
  path '/v3/qualibat/certifications_batiment/{siret}' do
    get SwaggerData.get('qualibat.certifications_batiment.title') do
      tags(*SwaggerData.get('qualibat.certifications_batiment.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { valid_siret(:qualibat) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:qualibat) }
      end

      describe 'with valid mandatory params', valid: true do
        response 200, 'Certification trouvée', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret' } do
          description SwaggerData.get('qualibat.certifications_batiment.description')

          schema build_rswag_document_response(
            id: valid_siret(:qualibat),
            document_url_properties: SwaggerData.get('qualibat.certifications_batiment.document_url_properties')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Certification non trouvée', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret' } do
          let(:siret) { not_found_siret(:qualibat) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
