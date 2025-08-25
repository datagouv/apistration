require 'swagger_helper'

RSpec.describe 'Infogreffe: Extraitsrcs', api: :entreprise, type: %i[request swagger] do
  path '/v3/infogreffe/rcs/unites_legales/{siren}/extrait_kbis' do
    get SwaggerData.get('infogreffe.extraits_rcs.title') do
      tags(*SwaggerData.get('infogreffe.extraits_rcs.tags'))

      common_action_attributes

      parameter_siren

      unauthorized_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      forbidden_request do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      too_many_requests(Infogreffe::ExtraitsRCS) do
        let(:siren) { valid_siren(:extrait_rcs) }
      end

      describe 'with valid token and mandatory params', :valid do
        response '200', 'Entreprise trouvée (personne morale)', vcr: { cassette_name: 'infogreffe/with_valid_siren_personne_morale' } do
          description SwaggerData.get('infogreffe.extraits_rcs.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('infogreffe.extraits_rcs.attributes')
          )

          run_test!
        end

        response '200', 'Entreprise trouvée (personne physique)', vcr: { cassette_name: 'infogreffe/with_valid_siren_personne_physique' } do
          let(:siren) { valid_siren(:extrait_rcs_personne_physique) }

          description SwaggerData.get('infogreffe.extraits_rcs.description')

          rate_limit_headers

          schema build_rswag_response(
            attributes: SwaggerData.get('infogreffe.extraits_rcs.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          let(:siren) { valid_siren(:extrait_rcs) }

          unprocessable_content_error_request(:siren)

          response '404', 'Non trouvée', vcr: { cassette_name: 'infogreffe/with_siren_not_found' } do
            let(:siren) { not_found_siren(:extrait_rcs) }

            build_rswag_example(NotFoundError.new('Infogreffe'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end

          common_provider_errors_request('Infogreffe', Infogreffe::ExtraitsRCS)
          common_network_error_request('Infogreffe', Infogreffe::ExtraitsRCS)
        end
      end
    end
  end
end
