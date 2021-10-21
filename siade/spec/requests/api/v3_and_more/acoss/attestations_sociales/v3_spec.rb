require 'swagger_helper'

RSpec.describe 'ACOSS: Attestations sociales', type: %i[request swagger] do
  path '/v3/acoss/attestations_sociales/{siren}' do
    get 'Récupération de l\'attestation sociale d\'une entreprise' do
      tags 'Attestations sociales et fiscales'

      common_action_attributes

      parameter name: :siren,
        in: :path,
        type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:acoss) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:acoss) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entreprise found', vcr: { cassette_name: 'acoss/with_valid_siren', match_requests_on: strict_match_vcr_requests_on_attributes.excluding(:body) } do
          let(:siren) { valid_siren(:acoss) }

          schema build_rswag_document_properties_response(
            siret: valid_siren(:acoss),
            document_url_extra_properties: {
              example: 'https://storage.entreprise.api.gouv.fr/siade/1569139162-b99824d9c764aae19a862a0af-attestation_vigilance_acoss.pdf',
              description: 'Lien vers l\'attestation de vigilance ACOSS. Ce document est automatiquement supprimé au bout de 3 mois.'
            }
          )

          run_test!
        end

        response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'acoss/with_non_existent_siren', match_requests_on: strict_match_vcr_requests_on_attributes.excluding(:body) } do
          let(:siren) { not_found_siren }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end
      end
    end
  end
end
