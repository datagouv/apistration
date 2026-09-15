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
        response '200', 'Entreprise trouvée' do
          description SwaggerData.get('cibtp.attestation_cotisations_conges_payes_chomage_intemperies.description')

          let(:siret) { valid_siret(:cibtp) }

          before do
            stub_cibtp_authenticate
            stub_cibtp_attestation_cotisations_conges_payes_chomage_intemperies_valid(siret:)
          end

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

          context 'with a siret with missing payments' do
            response '404', 'Missing payments' do
              let(:siret) { '81112965900025' }

              before do
                stub_cibtp_authenticate
                stub_cibtp_attestation_cotisations_conges_payes_chomage_intemperies_missing_payments(siret:)
              end

              build_rswag_example(CIBTPMissingPaymentsError.new)

              run_test!
            end
          end

          context 'with a not found siret' do
            response '404', 'Non trouvée' do
              let(:siret) { not_found_siret(:cibtp) }

              before do
                stub_cibtp_authenticate
                stub_cibtp_attestation_cotisations_conges_payes_chomage_intemperies_not_found(siret:)
              end

              build_rswag_example(NotFoundError.new('CIBTP'))

              schema '$ref' => '#/components/schemas/Error'

              run_test!
            end
          end

          common_provider_errors_request('CIBTP', CIBTP::AttestationCotisationsCongesPayesChomageIntemperies)

          common_network_error_request('CIBTP', CIBTP::AttestationCotisationsCongesPayesChomageIntemperies)
        end
      end
    end
  end
end
