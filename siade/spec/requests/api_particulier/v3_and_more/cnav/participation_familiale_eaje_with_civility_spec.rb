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

            context 'with X-Generate-Proof on a mocked not found (staging)' do
              before { allow(Rails.env).to receive(:staging?).and_return(true) }

              let(:nomNaissance) { 'LEFEBVRE' }
              let(:sexeEtatCivil) { 'F' }
              let(:codeCogInseeCommuneNaissance) { '08404' }
              let(:'X-Generate-Proof') { 'proof-only' }

              run_test! do |response|
                json = JSON.parse(response.body)

                expect(json['errors'].first['code']).to eq('37003')
                expect(json).not_to have_key('meta')
              end
            end

            context 'with X-Generate-Proof' do
              around { |example| Timecop.freeze(called_at) { example.run } }

              before { Rack::Attack.reset! }

              let(:called_at) { Time.zone.now.change(hour: 9, min: 7) }
              let(:'X-Generate-Proof') { 'pdf' }
              let(:json) { JSON.parse(body) }
              let(:pdf_payload) do
                AttestationToken.read(json['links']['attestation_pdf'][%r{/api/attestations/(.+)\.pdf\z}, 1], purpose: AttestationToken::PDF_PURPOSE)
              end
              let(:verification_payload) do
                AttestationToken.read(json['meta']['verification_url'].split('/').last, purpose: AttestationToken::VERIFICATION_PURPOSE)
              end

              def result_section(title, detail, origin)
                {
                  'titre' => 'Résultat de la consultation',
                  'entrees' => [[
                    ['Résultat', title],
                    ['Détail', detail],
                    ['Origine', origin],
                    ['Consultation effectuée le', called_at.strftime('%d/%m/%Y à %H:%M')]
                  ]]
                }
              end

              def stub_cnav_response(status:, regime:, body:)
                stub_request(:get, cnav_url('participation_familiale_eaje'))
                  .with(query: hash_including({}))
                  .to_return(status:, headers: { 'X-APISECU-FD' => CNAV::RetrieverOrganizer::REGIME_CODE_FROM_LABEL[regime] }, body:)
              end

              run_test! 'attests an RNCPS « Allocataire non référencé » with the identity as sent' do
                expect(json['errors'].pluck('title')).to eq(['Allocataire non référencé'])
                expect(json['meta'].keys).to contain_exactly('verification_url', 'verification_code', 'attestation_pdf_url_expires_at')
                expect(json['links'].keys).to contain_exactly('attestation_pdf')
                expect(json['meta']['verification_code']).to eq(AttestationToken.visual_code(pdf_payload['verification_token']))

                expect(pdf_payload).to include(
                  'document' => 'participation_familiale_eaje',
                  'titre' => 'ATTESTATION DE CONSULTATION SANS RÉSULTAT (PARTICIPATION FAMILIALE EAJE)',
                  'source' => 'RNCPS',
                  'siret' => '13002526500013',
                  'emise_le' => Time.zone.today.iso8601
                )
                expect(pdf_payload['sections']).to eq([
                  result_section('Allocataire non référencé', "L'allocataire n'est pas référencé auprès des caisses éligibles", 'RNCPS'),
                  {
                    'titre' => "Identité de l'usager transmise lors de l'appel",
                    'entrees' => [[
                      ['Nom de naissance', 'CHAMPION'],
                      ['Prénoms', 'JEAN-PASCAL'],
                      ['Date de naissance', '12/06/1980'],
                      ['Sexe', 'Masculin'],
                      ['Code INSEE de la commune de naissance', '17300'],
                      ['Code INSEE du pays de naissance', '99100']
                    ]]
                  }
                ])
              end

              %w[CNAF MSA].each do |regime|
                context "when the #{regime} has no file" do
                  before { stub_cnav_response(status: 404, regime:, body: { errorCode: 40_401, error: 'Dossier absent' }.to_json) }

                  run_test! "attests « Dossier allocataire absent #{regime} » with #{regime} as origin" do
                    expect(json['errors'].pluck('title')).to eq(["Dossier allocataire absent #{regime}"])
                    expect(pdf_payload['source']).to eq(regime)
                    expect(pdf_payload['sections'].first)
                      .to eq(result_section("Dossier allocataire absent #{regime}", "Le dossier allocataire n'a pas été trouvé auprès de la #{regime}.", regime))
                  end
                end

                context "when the #{regime} file has no child under 7" do
                  before { stub_cnav_response(status: 200, regime:, body: read_payload_file('cnav/participation_familiale_eaje/make_request_no_kids_under_7.json')) }

                  run_test! "attests « Allocataire non éligible » with #{regime} as origin" do
                    expect(json['errors'].pluck('title')).to eq(['Allocataire non éligible'])
                    expect(pdf_payload['source']).to eq(regime)
                    expect(pdf_payload['sections'].first)
                      .to eq(result_section('Allocataire non éligible', "Le dossier allocataire a été trouvé mais n'est pas éligible à la participation familiale EAJE", regime))
                  end
                end
              end

              context 'with a birthplace by name and a typographic apostrophe' do
                let(:nomNaissance) { 'D’ARTAGNAN' }
                let(:'prenoms[]') { %w[CHARLES OGIER] }
                let(:codeCogInseeCommuneNaissance) { nil }
                let(:nomCommuneNaissance) { 'LUPIAC' }
                let(:codeCogInseeDepartementNaissance) { '32' }

                run_test! 'shows the identity exactly as sent, before any normalisation' do
                  expect(pdf_payload['sections'].last['entrees']).to eq([[
                    ['Nom de naissance', 'D’ARTAGNAN'],
                    ['Prénoms', 'CHARLES OGIER'],
                    ['Date de naissance', '12/06/1980'],
                    ['Sexe', 'Masculin'],
                    ['Commune de naissance', 'LUPIAC'],
                    ['Département de naissance', '32'],
                    ['Code INSEE du pays de naissance', '99100']
                  ]])
                  expect(verification_payload['sections'].last['entrees']).to eq([[['Nom de naissance', 'D’A•••'], ['Date de naissance', '06/1980']]])
                end
              end

              context 'when monitoring records the retriever context' do
                let(:reported_contexts) { [] }

                before do
                  allow(MonitoringService.instance).to receive(:set_retriever_context) { |context| reported_contexts << context.to_h }
                end

                run_test! 'leaves the identity as sent out of it' do
                  expect(reported_contexts).not_to be_empty
                  expect(reported_contexts.flat_map(&:keys)).not_to include(:params_as_sent)
                end
              end

              context 'with X-Generate-Proof: proof-only' do
                let(:'X-Generate-Proof') { 'proof-only' }

                run_test! 'carries the verification link and code only, with a minimised identity' do
                  expect(json['meta'].keys).to contain_exactly('verification_url', 'verification_code')
                  expect(json).not_to have_key('links')
                  expect(verification_payload['sections']).to eq([
                    result_section('Allocataire non référencé', "L'allocataire n'est pas référencé auprès des caisses éligibles", 'RNCPS'),
                    {
                      'titre' => "Identité de l'usager transmise lors de l'appel",
                      'entrees' => [[['Nom de naissance', 'CHA•••'], ['Date de naissance', '06/1980']]]
                    }
                  ])
                  expect(verification_payload.to_json).not_to include('CHAMPION')
                end
              end

              context 'when building the proof fails' do
                before do
                  allow(AttestationToken).to receive(:generate).and_call_original
                  allow(AttestationToken).to receive(:generate)
                    .with(anything, hash_including(purpose: AttestationToken::PDF_PURPOSE))
                    .and_raise('PDF token failure')
                  allow(MonitoringService.instance).to receive(:track_with_added_context)
                end

                run_test! 'answers the 404 without proof and reports the failure to monitoring' do
                  expect(json.keys).to eq(['errors'])
                  expect(json['errors'].pluck('title')).to eq(['Allocataire non référencé'])
                  expect(MonitoringService.instance).to have_received(:track_with_added_context)
                    .with('error', a_string_including('proof'), hash_including(exception: 'RuntimeError', message: 'PDF token failure'))
                end
              end
            end
          end
        end

        common_provider_errors_request(CNAV::ParticipationFamilialeEAJE)
        common_network_error_request(CNAV::ParticipationFamilialeEAJE)
      end
    end
  end
end
