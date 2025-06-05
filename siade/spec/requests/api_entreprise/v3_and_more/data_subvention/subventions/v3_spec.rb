require 'swagger_helper'

RSpec.describe 'DataSubvention: Subventions', api: :entreprise, type: %i[request swagger] do
  path '/v3/data_subvention/subventions/{siren_or_siret_or_rna}' do
    get SwaggerData.get('data_subvention.subventions.title') do
      tags(*SwaggerData.get('data_subvention.subventions.tags'))

      common_action_attributes

      parameter name: :siren_or_siret_or_rna,
        in: :path,
        type: SwaggerData.get('data_subvention.subventions.parameters.siren_or_siret_or_rna.type'),
        description: SwaggerData.get('data_subvention.subventions.parameters.siren_or_siret_or_rna.description'),
        example: SwaggerData.get('data_subvention.subventions.parameters.siren_or_siret_or_rna.example'),
        required: SwaggerData.get('data_subvention.subventions.parameters.siren_or_siret_or_rna.required')

      before do
        stub_datasubvention_subventions_authenticate
      end

      unauthorized_request do
        let(:siren_or_siret_or_rna) { valid_siren(:data_subvention) }
      end

      forbidden_request do
        let(:siren_or_siret_or_rna) { valid_siren(:data_subvention) }
      end

      too_many_requests(DataSubvention::Subventions) do
        let(:siren_or_siret_or_rna) { valid_siren(:data_subvention) }
      end

      let(:siren_or_siret_or_rna) { valid_siren }

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_datasubvention_subventions_valid(id: siren_or_siret_or_rna)
        end

        response '200', 'Entreprise trouvée' do
          description SwaggerData.get('data_subvention.subventions.description')

          rate_limit_headers

          schema build_rswag_response_collection(
            properties: SwaggerData.get('data_subvention.subventions.attributes')
          )

          run_test!
        end
      end

      describe 'server errors', :valid do
        let(:siren_or_siret_or_rna) { valid_siren }

        unprocessable_entity_error_request(:siren_or_siret_or_rna) do
          let(:siren_or_siret_or_rna) { 'lol' }
        end

        context 'when the SIREN is valid but not found' do
          before do
            stub_datasubvention_subventions_404(id: siren_or_siret_or_rna)
          end

          response '404', 'Non trouvée' do
            let(:siren_or_siret_or_rna) { valid_siren }

            build_rswag_example(NotFoundError.new('DataSubvention'))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        common_provider_errors_request('DataSubvention', DataSubvention::Subventions)
        common_network_error_request('DataSubvention', DataSubvention::Subventions)
      end
    end
  end
end
