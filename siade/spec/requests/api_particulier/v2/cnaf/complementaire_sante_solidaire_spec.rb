require 'swagger_helper'

RSpec.describe 'CNAF: Complementaire Santé Solidaire', api: :particulier, type: %i[request swagger] do
  path '/api/v2/complementaire-sante-solidaire' do
    get SwaggerData.get('cnaf.c2s.title') do
      tags(*SwaggerData.get('cnaf.c2s.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :nomUsage,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.nomUsage.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.nomUsage.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.nomUsage.example'),
        required: false

      parameter name: :nomNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.nomNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.nomNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.nomNaissance.example'),
        required: false

      parameter name: :'prenoms[]',
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.prenoms.type'),
          minItems: SwaggerData.get('cnaf.c2s.parameters.prenoms.minItems'),
          items: { type: :string },
          example: SwaggerData.get('cnaf.c2s.parameters.prenoms.example')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.prenoms.description'),
        required: false

      parameter name: :anneeDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.anneeDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.anneeDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.anneeDateDeNaissance.example'),
        required: false

      parameter name: :moisDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.moisDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.moisDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.moisDateDeNaissance.example'),
        required: false

      parameter name: :jourDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.c2s.parameters.jourDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.c2s.parameters.jourDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.c2s.parameters.jourDateDeNaissance.example'),
        required: false

      parameter name: :codeInseeLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.codeInseeLieuDeNaissance.description'),
        required: false

      parameter name: :codePaysLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.description'),
        required: SwaggerData.get('cnaf.c2s.parameters.codePaysLieuDeNaissance.required')

      parameter name: :sexe,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.c2s.parameters.sexe.type'),
          enum: SwaggerData.get('cnaf.c2s.parameters.sexe.enum')
        },
        description: SwaggerData.get('cnaf.c2s.parameters.sexe.description'),
        required: SwaggerData.get('cnaf.c2s.parameters.sexe.required'),
        example: SwaggerData.get('cnaf.c2s.parameters.sexe.example')

      let(:'X-Api-Key') { TokenFactory.new(scopes).valid(jti: uid) }
      let(:request_token) { 'super_valid_token' }
      let(:uid) { SecureRandom.uuid }

      let(:scopes) { %i[complementaire_sante_solidaire] }

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:sexe) { 'M' }
      let(:anneeDateDeNaissance) { 1980 }
      let(:moisDateDeNaissance) { 6 }
      let(:jourDateDeNaissance) { 12 }
      let(:codePaysLieuDeNaissance) { '99100' }
      let(:codeInseeLieuDeNaissance) { '17300' }

      before do
        stub_cnaf_complementaire_sante_solidaire_authenticate
        stub_cnaf_complementaire_sante_solidaire_valid(siret: uid)
      end

      describe 'with valid token and mandatory params' do
        response '200', 'Quotient Familial trouvée' do
          description SwaggerData.get('cnaf.quotient-familial-v2.description')

          schema build_rswag_response_api_particulier(
            attributes: SwaggerData.get('cnaf.quotient-familial-v2.attributes')
          )

          run_test!
        end
      end

      describe 'server errors' do
        response '400', 'Mauvais paramètres d\'appels' do
          let(:sexe) { 'nope' }

          build_rswag_example(UnprocessableEntityError.new(:gender), :unprocessable_entity_error_gender_error)

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '404', 'Dossier complémentaire inexistant. Le document ne peut être édité.' do
          before do
            stub_cnaf_complementaire_sante_solidaire_404
          end

          let(:codePaysLieuDeNaissance) { '99623' }

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '503', 'Erreur du fournisseur' do
          provider_unknown_error = ProviderUnknownError.new('CNAF')

          stubbed_organizer_error(
            CNAF::ComplementaireSanteSolidaire,
            provider_unknown_error
          )

          schema '$ref' => '#/components/schemas/Error'

          build_rswag_example(provider_unknown_error, :unknown_error)

          run_test!
        end

        response '504', 'Erreur d\'intermédiaire' do
          schema '$ref' => '#/components/schemas/Error'

          provider_timeout_error = ProviderTimeoutError.new('CNAF')

          stubbed_organizer_error(
            CNAF::ComplementaireSanteSolidaire,
            provider_timeout_error
          )

          run_test!
        end
      end
    end
  end
end
