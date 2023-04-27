require 'swagger_helper'

RSpec.describe 'MESRI: Scolarites', api: :particulier, type: %i[request swagger] do
  path '/api/v2/scolarites' do
    get SwaggerData.get('mesri.scolarite.title') do
      tags(*SwaggerData.get('mesri.scolarite.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :nom,                in: :query, type: :string
      parameter name: :prenom,             in: :query, type: :string
      parameter name: :sexe,               in: :query, type: :string
      parameter name: :dateNaissance,     in: :query, type: :string
      parameter name: :codeEtablissement, in: :query, type: :string
      parameter name: :anneeScolaire,     in: :query, type: :string

      # rubocop:disable RSpec/VariableName
      let(:'X-Api-Key') { x_api_key }

      let(:dateNaissance) { '2000-06-10' }
      let(:codeEtablissement) { '0511474A' }
      let(:anneeScolaire) { '2021' }
      # rubocop:enable RSpec/VariableName
      let(:nom) { 'NOMFAMILLE' }
      let(:prenom) { 'prenom' }
      let(:sexe) { 'f' }

      let(:x_api_key) { nil }

      describe 'with valid token and mandatory params' do
        let(:x_api_key) { TokenFactory.new(['mesri_scolarites']).valid }

        response '200', 'Scolarité trouvée', vcr: { cassette_name: 'mesri/scolarites/valid' } do
          description SwaggerData.get('mesri.scolarite.description')

          schema build_rswag_response_api_particulier(
            attributes: SwaggerData.get('mesri.scolarite.attributes')
          )

          run_test!
        end

        describe 'server errors' do
          # unprocessable_entity_error_request do
          #   let(:sexe) { 'whatever' }
          # end

          response '404', 'Non trouvée', vcr: { cassette_name: 'mesri/scolarites/not_found' } do
            let(:sexe) { 'f' }

            run_test!
          end

          # common_provider_errors_request('MESRI', MESRI::Scolarites)

          # common_network_error_request('MESRI', MESRI::Scolarites)
        end
      end
    end
  end
end
