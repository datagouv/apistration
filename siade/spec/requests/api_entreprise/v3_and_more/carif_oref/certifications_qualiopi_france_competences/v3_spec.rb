require 'swagger_helper'

RSpec.describe 'CARIF-OREF: Certifications Qualiopi France Compétences', api: :entreprise, type: %i[request swagger] do
  path '/v3/carif_oref/etablissements/{siret}/certifications_qualiopi_france_competences' do
    get SwaggerData.get('carif_oref.certifications_qualiopi_france_competences.title') do
      tags(*SwaggerData.get('carif_oref.certifications_qualiopi_france_competences.tags'))

      parameter_siret

      common_action_attributes

      unauthorized_request do
        let(:siret) { valid_siret(:carif_oref) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:carif_oref) }
      end

      too_many_requests(CarifOref::CertificationsQualiopiFranceCompetences) do
        let(:siret) { valid_siret(:carif_oref) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'carif_oref/certifications_qualiopi_france_competences/valid_siret' } do
          let(:siret) { valid_siret(:carif_oref) }

          description SwaggerData.get('carif_oref.certifications_qualiopi_france_competences.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('carif_oref.certifications_qualiopi_france_competences.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret(:carif_oref) }

          unprocessable_content_error_request(:siret) do
            let(:siret) { 'lol' }
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'carif_oref/certifications_qualiopi_france_competences/no_data' } do
            let(:siret) { not_found_siret }

            build_rswag_example(NotFoundError.new('CARIF-OREF'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('CARIF-OREF', CarifOref::CertificationsQualiopiFranceCompetences)

          common_network_error_request('CARIF-OREF', CarifOref::CertificationsQualiopiFranceCompetences)
        end
      end
    end
  end
end
