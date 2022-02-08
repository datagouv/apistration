require 'swagger_helper'

RSpec.describe 'Infogreffe: Mandataires sociaux', type: %i[request swagger] do
  path '/v3/infogreffe/mandataires_sociaux/{siren}' do
    get "Récupération des mandataires sociaux d'une entreprise" do
      tags(*SwaggerData.get('infogreffe.mandataires_sociaux.tags'))

      common_action_attributes

      parameter name: :siren, in: :path, type: :string

      unauthorized_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      describe 'with valid mandatory params', valid: true do
        response '200', 'Entité trouvée', vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_valid_siren' } do
          description SwaggerData.get('infogreffe.mandataires_sociaux.description')

          schema build_rswag_response(
            id: valid_siren(:extrait_rcs),
            type: 'mandataires_sociaux',
            attributes: SwaggerData.get('infogreffe.mandataires_sociaux.attributes')
          )

          rate_limit_headers

          run_test!
        end

        response '404', 'Entreprise non trouvée',
          vcr: { cassette_name: 'infogreffe/mandataires_sociaux/with_siren_not_found' } do
          let(:siren) { not_found_siren(:extrait_rcs) }

          schema '$ref' => '#/components/schemas/NotFound'

          run_test!
        end

        response '422', 'Unprocessable entity', vcr: { cassette_name: 'mi/associations/unprocessable_entity' } do
          let(:siren) { 'random_content' }

          schema '$ref' => '#/components/schemas/UnprocessableEntity'

          run_test!
        end
      end
    end
  end
end
