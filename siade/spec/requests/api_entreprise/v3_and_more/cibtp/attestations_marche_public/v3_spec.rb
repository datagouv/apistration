require 'swagger_helper'

RSpec.describe 'CIBTP: Attestationsmarchepublic', api: :entreprise, type: %i[request swagger] do
  path '/v3/cibtp/attestations_marche_public/{siret}' do
    get SwaggerData.get('cibtp.attestations_marche_public.title') do
      tags(*SwaggerData.get('cibtp.attestations_marche_public.tags'))

      common_action_attributes

      parameter name: :siret, in: :path, type: :string

      unauthorized_request do
        let(:siret) { valid_siret(:cibtp) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:cibtp) }
      end

      too_many_requests(CIBTP::AttestationsMarchePublic) do
        let(:siret) { valid_siret(:cibtp) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'cibtp/attestations_marche_public/valid' } do
          description SwaggerData.get('cibtp.attestations_marche_public.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('cibtp.attestations_marche_public.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret(:cibtp) }

          unprocessable_entity_error_request(:siret) do
            let(:siret) { 'lol' }
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'cibtp/attestations_marche_public/not_found' } do
            let(:siret) { not_found_siret(:cibtp) }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '409', 'Conflict' do
            let(:siret) { valid_siret }

            before do
              stub_cibtp_authenticate
              stub_cibtp_attestations_marche_public_conflict(siret:)
            end

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '422', 'Missing payments', vcr: { cassette_name: 'cibtp/attestations_marche_public/missing_payments' } do
            let(:siret) { '81112965900025' }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('CIBTP', CIBTP::AttestationsMarchePublic)

          common_network_error_request('CIBTP', CIBTP::AttestationsMarchePublic)
        end
      end
    end
  end
end
