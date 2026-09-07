require 'swagger_helper'

RSpec.describe 'Qualibat : CertificationsBatiment', api: :entreprise, type: %i[request swagger] do
  path '/v3/qualibat/etablissements/{siret}/certification_batiment' do
    get SwaggerData.get('qualibat.certifications_batiment.title.v3') do
      tags(*SwaggerData.get('qualibat.certifications_batiment.tags'))

      parameter_siret
      deprecated true

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

      before { stub_qualibat_authenticate }

      describe 'with valid token and mandatory params', :valid do
        response 200, 'Certification trouvée' do
          before { stub_qualibat_valid_siret }

          description SwaggerData.get('qualibat.certifications_batiment.description')

          schema build_rswag_document_response(
            document_url_properties: SwaggerData.get('qualibat.certifications_batiment.document_url_properties')
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

          response '404', 'Certification non trouvée' do
            let(:siret) { not_found_siret(:qualibat) }

            before { stub_qualibat_not_found_siret }

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
