require 'swagger_helper'

RSpec.describe 'CNAF: Quotient Familial V2', api: :particulier, type: %i[request swagger] do
  path '/api/v2/composition-familiale-v2' do
    get SwaggerData.get('cnaf.quotient-familial-v2.title') do
      tags(*SwaggerData.get('cnaf.quotient-familial-v2.tags'))

      produces 'application/json'

      parameter name: 'X-Api-Key', in: :header, type: :string

      parameter name: :nomUsage,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomUsage.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomUsage.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomUsage.example'),
        required: false

      parameter name: :nomNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.nomNaissance.example'),
        required: false

      parameter name: :'prenoms[]',
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.type'),
          minItems: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.minItems'),
          items: { type: :string },
          example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.example')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.prenoms.description'),
        required: false

      parameter name: :anneeDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.anneeDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.anneeDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.anneeDateDeNaissance.example'),
        required: false

      parameter name: :moisDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.moisDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.moisDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.moisDateDeNaissance.example'),
        required: false

      parameter name: :jourDateDeNaissance,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.jourDateDeNaissance.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.jourDateDeNaissance.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.jourDateDeNaissance.example'),
        required: false

      parameter name: :codeInseeLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codeInseeLieuDeNaissance.description'),
        required: false

      parameter name: :codePaysLieuDeNaissance,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.type'),
          minLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.minLength'),
          maxLength: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.maxLength'),
          example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.example')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.description'),
        required: SwaggerData.get('cnaf.quotient-familial-v2.parameters.codePaysLieuDeNaissance.required')

      parameter name: :sexe,
        in: :query,
        schema: {
          type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.type'),
          enum: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.enum')
        },
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.description'),
        required: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.required'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.sexe.example')

      parameter name: :annee,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.annee.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.annee.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.annee.example'),
        required: false

      parameter name: :mois,
        in: :query,
        type: SwaggerData.get('cnaf.quotient-familial-v2.parameters.mois.type'),
        description: SwaggerData.get('cnaf.quotient-familial-v2.parameters.mois.description'),
        example: SwaggerData.get('cnaf.quotient-familial-v2.parameters.mois.example'),
        required: false

      let(:'X-Api-Key') { TokenFactory.new(scopes).valid }
      let(:request_token) { 'super_valid_token' }
      let(:uid) { SecureRandom.uuid }

      let(:scopes) { %i[cnaf_quotient_familial cnaf_allocataires cnaf_enfants cnaf_adresse] }

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:sexe) { 'M' }
      let(:anneeDateDeNaissance) { 1980 }
      let(:moisDateDeNaissance) { 6 }
      let(:jourDateDeNaissance) { 12 }
      let(:codePaysLieuDeNaissance) { '99100' }
      let(:codeInseeLieuDeNaissance) { '17300' }
      let(:mois) { 12 }
      let(:annee) { 2023 }

      before do
        stub_cnaf_quotient_familial_v2_authenticate
        stub_cnaf_quotient_familial_v2_valid(siret: '100000009')
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

        response '404', 'Dossier allocataire inexistant. Le document ne peut être édité.' do
          before do
            stub_cnaf_quotient_familial_v2_404
          end

          let(:codePaysLieuDeNaissance) { '99623' }

          schema '$ref' => '#/components/schemas/Error'

          run_test!
        end

        response '503', 'Erreur du fournisseur' do
          provider_unknown_error = ProviderUnknownError.new('CNAF')

          stubbed_organizer_error(
            CNAF::QuotientFamilialV2,
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
            CNAF::QuotientFamilialV2,
            provider_timeout_error
          )

          run_test!
        end
      end
    end
  end
end
