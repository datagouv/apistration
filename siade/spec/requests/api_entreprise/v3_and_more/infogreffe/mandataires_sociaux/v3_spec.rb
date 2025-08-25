require 'swagger_helper'

RSpec.describe 'Infogreffe: Mandataires sociaux', api: :entreprise, type: %i[request swagger] do
  path '/v3/infogreffe/rcs/unites_legales/{siren}/mandataires_sociaux' do
    get SwaggerData.get('infogreffe.mandataires_sociaux.title') do
      tags(*SwaggerData.get('infogreffe.mandataires_sociaux.tags'))

      parameter_siren

      common_action_attributes

      unauthorized_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      too_many_requests(Infogreffe::MandatairesSociaux) do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entité trouvée', vcr: { cassette_name: 'infogreffe/with_valid_siren_personne_morale' } do
          description SwaggerData.get('infogreffe.mandataires_sociaux.description')

          schema build_rswag_response_collection(
            example: SwaggerData.get('infogreffe.mandataires_sociaux.example'),
            required: SwaggerData.get('infogreffe.mandataires_sociaux.items.required'),
            properties: SwaggerData.get('infogreffe.mandataires_sociaux.items.properties'),
            meta: SwaggerData.get('infogreffe.mandataires_sociaux.meta')
          )

          rate_limit_headers

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:extrait_rcs) }

          unprocessable_content_error_request(:siren)

          response '404', 'Entreprise non trouvée', vcr: { cassette_name: 'infogreffe/with_siren_not_found' } do
            let(:siren) { not_found_siren(:extrait_rcs) }

            build_rswag_example(NotFoundError.new('Infogreffe'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('Infogreffe', Infogreffe::MandatairesSociaux)
          common_network_error_request('Infogreffe', Infogreffe::MandatairesSociaux)
        end
      end
    end
  end
end
