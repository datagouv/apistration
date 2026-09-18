require 'swagger_helper'

RSpec.describe 'Nomenclature des erreurs', api: :entreprise, type: %i[request swagger] do
  path '/errors' do
    get 'Nomenclature des codes erreurs' do
      tags 'Disponibilité'
      description "Retourne la nomenclature complète des codes erreurs : les préfixes fournisseurs, les sous-codes communs, les codes de la plateforme et, pour chaque opération, les erreurs qu'elle peut renvoyer groupées par statut HTTP.\n\nCet endpoint **ne nécessite pas d'authentification**."
      security []
      produces 'application/json'

      parameter name: :operation_id,
        in: :query,
        type: :string,
        required: false,
        description: "Restreint `endpoints` à cette seule opération (valeur du `x-operationId` d'un endpoint)",
        example: 'api_entreprise_v3_insee_unites_legales'

      response '200', 'Nomenclature des codes erreurs' do
        let(:operation_id) { nil }

        schema build_errors_nomenclature_schema

        run_test! do |response|
          expect(JSON.parse(response.body)).to eq(YAML.load_file(Rails.root.join('config/errors_entreprise.yml'), aliases: true))
          expect(response.headers['Cache-Control']).to include('max-age=3600', 'public')
        end
      end

      response '200', 'Nomenclature restreinte à une opération', document: false do
        let(:operation_id) { 'api_entreprise_v3_insee_unites_legales' }

        run_test! do |response|
          expect(JSON.parse(response.body)['endpoints'].keys).to eq([operation_id])
        end
      end

      response '404', 'Opération inconnue' do
        let(:operation_id) { 'api_particulier_v3_cnav_prime_activite_with_civility' }

        schema '$ref' => '#/components/schemas/Error'

        build_rswag_example(UnknownOperationError.new('api_particulier_v3_cnav_prime_activite_with_civility'))

        run_test!
      end
    end
  end
end
