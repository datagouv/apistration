require 'swagger_helper'

RSpec.describe 'CNETP: Attestations cotisations congés payés et aux chômage-intempéries', type: %i[request swagger] do
  path '/v3/cnetp/attestations_cotisations_conges_payes_chomage_intemperies/{siren}' do
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

      describe 'with valid mandatory params', valid: true do
        response '200', 'Certificat trouvé', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/valid_siren' } do
          description SwaggerData.get('cnetp.attestation_cotisations_conges_payes_chomage_intemperies.description')

          schema build_rswag_document_response(
            id: eligible_siret(:probtp),
            document_url_properties: SwaggerData.get('probtp.attestation_cotisation_retraite.document_url_properties')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Non trouvé', vcr: { cassette_name: 'cnetp/attestation_cotisations_conges_payes_chomage_intemperies/not_found_siren' } do
          let(:siren) { not_found_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
