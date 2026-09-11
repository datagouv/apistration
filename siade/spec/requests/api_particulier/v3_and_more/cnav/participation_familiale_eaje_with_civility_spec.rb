require 'swagger_helper'

RSpec.describe 'API Particulier CNAV: Participation familiale EAJE with civility', api: :particulier, type: %i[request swagger] do
  path '/v3/dss/participation_familiale_eaje/identite' do
    get "[Identité] #{SwaggerData.get('cnav.eaje.title')}" do
      tags(*SwaggerData.get('cnav.eaje.tags'))

      common_action_attributes

      cacheable_request

      parameters_identite_pivot(
        params: %w[
          nomNaissance
          nomUsage
          prenoms
          anneeDateNaissance
          moisDateNaissance
          jourDateNaissance
          sexeEtatCivil
          codeCogInseePaysNaissance
          codeCogInseeCommuneNaissance
          nomCommuneNaissance
          codeCogInseeDepartementNaissance
        ],
        required: %w[
          nomNaissance
          prenoms
          codeCogInseePaysNaissance
        ],
        api: 'cnav'
      )

      parameter name: 'X-Generate-Proof',
        in: :header,
        required: false,
        schema: { type: :string, enum: %w[proof-only pdf] },
        description: "Demande une preuve d'attestation : `proof-only` ajoute `meta.verification_url` et `meta.verification_code` ; `pdf` ajoute en plus `links.attestation_pdf` (téléchargement sans authentification, expiration `meta.attestation_pdf_url_expires_at`)."

      let(:nomNaissance) { 'CHAMPION' }
      let(:'prenoms[]') { %w[JEAN-PASCAL] }
      let(:sexeEtatCivil) { 'M' }
      let(:anneeDateNaissance) { 1980 }
      let(:moisDateNaissance) { 6 }
      let(:jourDateNaissance) { 12 }
      let(:codeCogInseePaysNaissance) { '99100' }
      let(:codeCogInseeCommuneNaissance) { '17300' }
      let(:codeCogInseeDepartementNaissance) { nil }
      let(:nomCommuneNaissance) { nil }
      let(:'X-Generate-Proof') { nil }

      unauthorized_request

      forbidden_request('api_particulier')

      too_many_requests(CNAV::ParticipationFamilialeEAJE)

      let(:scopes) { %i[cnav_participation_familiale_eaje_allocataires cnav_participation_familiale_eaje_enfants cnav_participation_familiale_eaje_adresse cnav_participation_familiale_eaje_parametres_calcul] }

      before do
        stub_cnav_authenticate('participation_familiale_eaje')
      end

      describe 'with valid token and mandatory params', :valid do
        before do
          stub_cnav_authenticate('participation_familiale_eaje')
        end

        context 'when found' do
          before do
            stub_cnav_valid('participation_familiale_eaje', siret: '13002526500013')
            allow(Rails.env).to receive(:staging?).and_return(true) if RSpec.current_example.metadata[:mocked_provider]
          end

          response '200', 'Dossier trouvé' do
            description SwaggerData.get('cnav.eaje.description')

            cacheable_response(extra_description: SwaggerData.get('cnav.commons.cache_duration'))

            rate_limit_headers

            schema build_rswag_response(
              attributes: SwaggerData.get('cnav.eaje.attributes')
            )

            run_test! do |response|
              json = JSON.parse(response.body)

              expect(json['links']).to eq({})
              expect(json['meta']).to eq({})
            end

            context 'with X-Generate-Proof: pdf on mocked data (staging)', :mocked_provider do
              let(:nomNaissance) { 'LEFEBVRE' }
              let(:'prenoms[]') { %w[ALEXIS GÉRÔME JEAN-PHILIPPE] }
              let(:sexeEtatCivil) { 'F' }
              let(:anneeDateNaissance) { 1982 }
              let(:moisDateNaissance) { 12 }
              let(:jourDateNaissance) { 27 }
              let(:codeCogInseeCommuneNaissance) { '08480' }
              let(:'X-Generate-Proof') { 'pdf' }

              run_test! do |response|
                json = JSON.parse(response.body)

                expect(json['data']['allocataires'].first['nom_naissance']).to eq('LEFEBVRE')
                expect(json['meta'].keys)
                  .to contain_exactly('verification_url', 'verification_code', 'attestation_pdf_url_expires_at')
                expect(json['links'].keys).to contain_exactly('attestation_pdf')
                expect(response.body.scan('"meta"').count).to eq(1)
                expect(response.body.scan('"links"').count).to eq(1)
              end
            end

            context 'with X-Generate-Proof: pdf' do
              let(:'X-Generate-Proof') { 'pdf' }

              run_test! do |response|
                json = JSON.parse(response.body)

                expect(json['meta'].keys)
                  .to contain_exactly('verification_url', 'verification_code', 'attestation_pdf_url_expires_at')
                expect(json['links'].keys).to contain_exactly('attestation_pdf')
                expect(json['links']['attestation_pdf'])
                  .to match(%r{\A#{AttestationToken.base_url}/api/attestations/[A-Za-z0-9_-]+(--[A-Za-z0-9_-]+)*\.pdf\z})

                expect(json['meta']['attestation_pdf_url_expires_at'])
                  .to be_between(4.minutes.from_now.to_i, 6.minutes.from_now.to_i)

                pdf_token = json['links']['attestation_pdf'][%r{/api/attestations/(.+)\.pdf\z}, 1]
                payload = AttestationToken.read(pdf_token, purpose: AttestationToken::PDF_PURPOSE)

                expect(payload['document']).to eq('participation_familiale_eaje')
                expect(payload['titre']).to eq('ATTESTATION DE PARTICIPATION FAMILIALE (EAJE)')
                expect(payload['source']).to eq('CNAF')
                expect(payload['sections'].pluck('titre'))
                  .to eq(['Allocataires', 'Enfants', 'Adresse', 'Paramètres de calcul de la participation familiale'])
                expect(payload['sections'].first['entrees'].first)
                  .to include(['Nom de naissance', json['data']['allocataires'].first['nom_naissance']])
                expect(payload['siret']).to eq('13002526500013')
                expect(payload['emise_le']).to eq(Time.zone.today.iso8601)
                expect(payload).to have_key('habilitation')
                expect(payload['verification_token']).to eq(json['meta']['verification_url'].split('/').last)
                expect(AttestationToken.visual_code(payload['verification_token']))
                  .to eq(json['meta']['verification_code'])
              end
            end

            context 'with X-Generate-Proof: proof-only' do
              let(:'X-Generate-Proof') { 'proof-only' }

              run_test! do |response|
                json = JSON.parse(response.body)

                expect(json['links']).to eq({})
                expect(json['meta'].keys).to contain_exactly('verification_url', 'verification_code')
                expect(json['meta']['verification_code']).to match(/\A[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{2}\z/)
                expect(json['meta']['verification_url'])
                  .to match(%r{\A#{AttestationToken.base_url}/attestations/verification/[A-Za-z0-9_-]+(--[A-Za-z0-9_-]+)*\z})
                expect(json['meta']['verification_url']).not_to include(URI.parse(response.request.url).host)

                token = json['meta']['verification_url'].split('/').last
                payload = AttestationToken.read(token, purpose: AttestationToken::VERIFICATION_PURPOSE)

                expect(payload['siret']).to eq('13002526500013')
                expect(payload['sections'].first).to eq(
                  'titre' => 'Allocataires',
                  'entrees' => [[['Nom de naissance', 'DUP•••'], ['Date de naissance', '06/1981']]]
                )
                expect(payload['sections'].pluck('titre'))
                  .to eq(['Allocataires', 'Enfants', 'Paramètres de calcul de la participation familiale'])
                expect(payload.to_json).not_to include('DUPOND')
                expect(json['meta']['verification_code']).to eq(AttestationToken.visual_code(token))
              end
            end

            context 'with X-Generate-Proof and a warm cache' do
              let(:'X-Generate-Proof') { 'proof-only' }

              run_test! 'bypasses the response cache — a proof is always built on fresh provider data' do
                Rack::Attack.reset!
                WebMock.reset_executed_requests!
                2.times do
                  submit_request(RSpec.current_example.metadata)
                  expect(response).to have_http_status(:ok)
                end

                expect(a_request(:get, cnav_url('participation_familiale_eaje'))
                  .with(query: hash_including({}))).to have_been_made.twice
              end
            end
          end

          response '400', "Valeur d'en-tête X-Generate-Proof inconnue" do
            let(:'X-Generate-Proof') { 'banana' }

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        context 'when not found' do
          before { stub_cnav_404('participation_familiale_eaje') }

          response '404', 'Dossier non trouvé' do
            build_rswag_example(NotFoundError.new('CNAV', 'Dossier allocataire inexistant. Le document ne peut être édité.', with_identifiant_message: false))

            schema '$ref' => '#/components/schemas/Error'

            run_test!
          end
        end

        common_provider_errors_request('CNAV', CNAV::ParticipationFamilialeEAJE)
        common_network_error_request('CNAV', CNAV::ParticipationFamilialeEAJE)
      end
    end
  end
end
