require 'swagger_helper'

RSpec.describe 'API Particulier: Mesri: Statut Etudiant with INE', api: :particulier, type: %i[request swagger] do
  path '/v3/mesri/statut_etudiant/ine' do
    get "[INE] #{SwaggerData.get('mesri.commons.title')}" do
      tags(*SwaggerData.get('mesri.commons.tags'))

      common_action_attributes

      unauthorized_request do
        let(:ine) { '1234567890A' }
      end

      forbidden_request('api_particulier') do
        let(:ine) { '1234567890A' }
      end

      too_many_requests(MESRI::StudentStatus::WithINE) do
        let(:ine) { '1234567890A' }
      end

      parameter name: :ine,
        in: :query,
        description: SwaggerData.get('mesri.statut_etudiant.parameters.ine.description'),
        example: SwaggerData.get('mesri.statut_etudiant.parameters.ine.example'),
        schema: {
          type: :string,
          pattern: SwaggerData.get('mesri.statut_etudiant.parameters.ine.pattern')
        },
        required: true

      parameter name: 'X-Generate-Proof',
        in: :header,
        required: false,
        schema: { type: :string, enum: %w[proof-only pdf] },
        description: "Demande une preuve d'attestation : `proof-only` ajoute `meta.verification_url` et `meta.verification_code` ; `pdf` ajoute en plus `links.attestation_pdf` (téléchargement sans authentification, expiration dans `meta.attestation_pdf_url_expires_in`, en secondes). Le PDF est l'attestation de statut étudiant, portant un QR code vers la page publique de vérification."

      let(:'X-Generate-Proof') { nil }

      let(:scopes) { %i[mesri_identite mesri_admissions mesri_admission_inscrit mesri_admission_regime_formation mesri_admission_commune_etudes mesri_admission_etablissement_etudes] }

      let(:ine) { '1234567890A' }

      describe 'with valid token and mandatory params', :valid do
        context 'when the student is found' do
          before do
            stub_mesri_valid
          end

          response '200', 'Étudiant identifié' do
            description SwaggerData.get('mesri.commons.description')

            schema build_rswag_response(
              attributes: SwaggerData.get('mesri.commons.attributes')
            )

            run_test!

            context 'with X-Generate-Proof: pdf' do
              let(:'X-Generate-Proof') { 'pdf' }

              run_test! do |response|
                json = JSON.parse(response.body)

                expect(json['meta'].keys)
                  .to contain_exactly('verification_url', 'verification_code', 'attestation_pdf_url_expires_in')
                expect(json['links'].keys).to contain_exactly('attestation_pdf')
              end
            end
          end

          response '400', "Valeur d'en-tête X-Generate-Proof inconnue" do
            let(:'X-Generate-Proof') { 'banana' }

            build_rswag_example(BadRequestError.new)

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        context 'when the student is not found' do
          before do
            stub_mesri_not_found
          end

          response '404', 'Étudiant non identifié' do
            schema '$ref' => '#/components/schemas/Error'

            build_rswag_example(NotFoundError.new('MESRI', "Aucun étudiant n'a pu être trouvé avec les critères de recherche fournis.", with_identifiant_message: false))

            run_test!
          end
        end

        common_provider_errors_request(MESRI::StudentStatus::WithINE)
        common_network_error_request(MESRI::StudentStatus::WithINE)
      end
    end
  end
end
