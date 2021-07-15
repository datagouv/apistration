require 'swagger_helper'

RSpec.describe 'PROBTP : Attestations cotisations retraite', type: %i[request swagger] do
  path '/v3/probtp/attestations_cotisation_retraite/{siret}' do
    get 'Récupération d\'une attestation' do
      tags 'Attestations sociales et fiscales'

      common_action_attributes

      parameter name: :siret, in: :path, type: :string

      unauthorized_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      forbidden_request do
        let(:siret) { eligible_siret(:probtp) }
      end

      describe 'with valid mandatory params', valid: true do
        response 200, 'Attestation found', vcr: { cassette_name: 'probtp/attestation/with_eligible_siret' } do
          schema build_rswag_document_properties_response(
            siret: eligible_siret(:probtp),
            document_url_extra_properties: {
              example: 'https://storage.entreprise.api.gouv.fr/siade/1569139162-b99824d9c764aae19a862a0af-attestation_cotisation_retraite_probtp.pdf',
              description: 'Lien vers l\'attestation ProBtp.',
            }
          )

          run_test!
        end

        response '404', 'Attestation non trouvée', vcr: { cassette_name: 'probtp/attestation/with_not_found_siret' } do
          let(:siret) { not_found_siret(:probtp) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
