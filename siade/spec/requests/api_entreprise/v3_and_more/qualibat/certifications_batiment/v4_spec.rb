require 'swagger_helper'

RSpec.describe 'Qualibat : Certifications Batiment', api: :entreprise, type: %i[request swagger] do
  path '/v4/qualibat/etablissements/{siret}/certification_batiment' do
    get SwaggerData.get('qualibat.certifications_batiment.title.v4') do
      tags(*SwaggerData.get('qualibat.certifications_batiment.tags'))

      cacheable_request

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { valid_siret(:qualibat) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:qualibat) }
      end

      too_many_requests(QUALIBAT::CertificationsBatiment) do
        let(:siret) { valid_siret(:qualibat) }
      end

      describe 'with valid token and mandatory params', :valid do
        response 200, 'Certification trouvée', vcr: { cassette_name: 'qualibat/certifications_batiment/valid_siret_2' } do
          description SwaggerData.get('qualibat.certifications_batiment.description')

          cacheable_response(extra_description: SwaggerData.get('qualibat.certifications_batiment.cache_duration'))

          schema build_rswag_response(
            attributes: SwaggerData.get('qualibat.certifications_batiment.properties')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret(:qualibat) }

          unprocessable_content_error_request(:siret)

          common_provider_errors_request(
            'Qualibat',
            QUALIBAT::CertificationsBatiment,
            documents_errors('Qualibat')
          )

          response '404', 'Certification non trouvée', vcr: { cassette_name: 'qualibat/certifications_batiment/not_found_siret_2' } do
            let(:siret) { not_found_siret(:qualibat) }

            build_rswag_example(NotFoundError.new('Qualibat'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('Qualibat', QUALIBAT::CertificationsBatiment)
        end
      end
    end
  end
end
