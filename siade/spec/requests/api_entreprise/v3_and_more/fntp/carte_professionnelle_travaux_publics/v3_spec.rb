require 'swagger_helper'

RSpec.describe 'FNTP: Carte professionnelle Travaux Publics', api: :entreprise, type: %i[request swagger] do
  path '/v3/fntp/unites_legales/{siren}/carte_professionnelle_travaux_publics' do
    get SwaggerData.get('fntp.carte_professionnelle_travaux_publics.title') do
      tags(*SwaggerData.get('fntp.carte_professionnelle_travaux_publics.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:fntp) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:fntp) }
      end

      too_many_requests(FNTP::CarteProfessionnelleTravauxPublics) do
        let(:siren) { valid_siren(:fntp) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Carte professionnelle trouvée', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/valid_siren' } do
          description SwaggerData.get('fntp.carte_professionnelle_travaux_publics.description')

          rate_limit_headers

          schema build_rswag_document_response(
            document_url_properties: SwaggerData.get('fntp.carte_professionnelle_travaux_publics.document_url_properties')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:fntp) }

          unprocessable_content_error_request(:siren)

          common_provider_errors_request(
            'FNTP',
            FNTP::CarteProfessionnelleTravauxPublics,
            documents_errors('FNTP')
          )

          response '404', 'Non trouvée', vcr: { cassette_name: 'fntp/carte_professionnelle_travaux_publics/not_found_siren' } do
            let(:siren) { not_found_siren }

            build_rswag_example(NotFoundError.new('FNTP'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('FNTP', FNTP::CarteProfessionnelleTravauxPublics)
        end
      end
    end
  end
end
