require 'swagger_helper'

RSpec.describe 'MI : Associations unite legales', api: :entreprise, type: %i[request swagger] do
  path '/v4/ministere_interieur/api-asso/unites_legales/{siren_or_rna}' do
    get SwaggerData.get('mi.v4/unite_legale.title') do
      tags(*SwaggerData.get('mi.v4/unite_legale.tags'))

      parameter_siren_or_rna

      common_action_attributes

      unauthorized_request do
        let(:siren_or_rna) { valid_rna_id }
      end

      forbidden_request do
        let(:siren_or_rna) { valid_rna_id }
      end

      describe 'with valid token and mandatory params', valid: true do
        response 200, 'Unite legale trouvée' do
          description SwaggerData.get('mi.v4/unite_legale.description')

          schema build_rswag_response(
            attributes: SwaggerData.get('mi.v4/unite_legale.attributes'),
            meta: SwaggerData.get('mi.v4/unite_legale.meta')
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

          unprocessable_entity_error_request(:siren_or_rna)

          response '404', 'Unité légale non trouvée', vcr: { cassette_name: 'mi/associations/with_rna_not_found' } do
            let(:siren_or_rna) { non_existing_rna_id }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('MI', MI::UniteLegale)
          common_provider_errors_request('MI', MI::UniteLegale)
        end
      end
    end
  end
end
