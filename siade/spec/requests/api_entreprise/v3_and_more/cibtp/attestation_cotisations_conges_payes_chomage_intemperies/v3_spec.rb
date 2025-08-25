require 'swagger_helper'

RSpec.describe 'CIBTP: AttestationCotisationsCongesPayesChomageIntemperies', api: :entreprise, type: %i[request swagger] do
  path '/v3/cibtp/etablissements/{siret}/attestation_cotisations_conges_payes_chomage_intemperies' do
    get SwaggerData.get('cibtp.attestation_cotisations_conges_payes_chomage_intemperies.title') do
      tags(*SwaggerData.get('cibtp.attestation_cotisations_conges_payes_chomage_intemperies.tags'))

      common_action_attributes

      parameter name: :siret, in: :path, type: :string

      unauthorized_request do
        let(:siret) { valid_siret(:cibtp) }
      end

      forbidden_request do
        let(:siret) { valid_siret(:cibtp) }
      end

      too_many_requests(CIBTP::AttestationCotisationsCongesPayesChomageIntemperies) do
        let(:siret) { valid_siret(:cibtp) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée', vcr: { cassette_name: 'cibtp/attestation_cotisations_conges_payes_chomage_intemperies/valid' } do
          description SwaggerData.get('cibtp.attestation_cotisations_conges_payes_chomage_intemperies.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('cibtp.attestation_cotisations_conges_payes_chomage_intemperies.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siret) { valid_siret(:cibtp) }

          unprocessable_content_error_request(:siret) do
            let(:siret) { 'lol' }
          end

          response '502', 'Conflict' do
            let(:siret) { valid_siret }

            before do
              stub_cibtp_authenticate
              stub_cibtp_attestation_cotisations_conges_payes_chomage_intemperies_conflict(siret:)
            end

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          response '404', 'Missing payments', vcr: { cassette_name: 'cibtp/attestation_cotisations_conges_payes_chomage_intemperies/missing_payments' } do
            let(:siret) { '81112965900025' }

            build_rswag_example(CIBTPMissingPaymentsError.new)

            run_test!
          end

          response '404', 'Non trouvée', vcr: { cassette_name: 'cibtp/attestation_cotisations_conges_payes_chomage_intemperies/not_found' } do
            let(:siret) { not_found_siret(:cibtp) }

            build_rswag_example(NotFoundError.new('CIBTP'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('CIBTP', CIBTP::AttestationCotisationsCongesPayesChomageIntemperies)

          common_network_error_request('CIBTP', CIBTP::AttestationCotisationsCongesPayesChomageIntemperies)
        end
      end
    end
  end
end
