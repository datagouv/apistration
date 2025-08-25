require 'swagger_helper'

RSpec.describe 'CNETP: Attestations cotisations congés payés et aux chômage intempéries', api: :entreprise, type: %i[request swagger] do
  path '/v3/cnetp/unites_legales/{siren}/attestation_cotisations_conges_payes_chomage_intemperies' do
    get SwaggerData.get('cnetp.attestation_cotisations_conges_payes_chomage_intemperies.title') do
      tags(*SwaggerData.get('cnetp.attestation_cotisations_conges_payes_chomage_intemperies.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:cnetp) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:cnetp) }
      end

      too_many_requests(CNETP::AttestationCotisationsCongesPayesChomageIntemperies) do
        let(:siren) { valid_siren(:cnetp) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Certificat trouvé', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/valid_siren' } do
          description SwaggerData.get('cnetp.attestation_cotisations_conges_payes_chomage_intemperies.description')

          schema build_rswag_document_response(document_url_properties: SwaggerData.get('cnetp.attestation_cotisations_conges_payes_chomage_intemperies.document_url_properties'))

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:cnetp) }

          unprocessable_content_error_request(:siren)

          common_provider_errors_request(
            'CNETP',
            CNETP::AttestationCotisationsCongesPayesChomageIntemperies,
            documents_errors('CNETP')
          )

          response '404', 'Non trouvé', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/not_found_siren' } do
            let(:siren) { not_found_siren }

            build_rswag_example(NotFoundError.new('CNETP'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_network_error_request('CNETP', CNETP::AttestationCotisationsCongesPayesChomageIntemperies)
        end
      end
    end
  end
end
