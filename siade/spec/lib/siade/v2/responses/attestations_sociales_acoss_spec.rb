RSpec.describe SIADE::V2::Responses::AttestationsSocialesACOSS, type: :provider_response do
  subject { request.perform.response }

  let(:request) do
    SIADE::V2::Requests::AttestationsSocialesACOSS.new(
      {
        siren: siren,
        type_attestation: 'AVG_UR',
        user_id: 'user id',
        recipient: 'SIRET of someone'
      }
    )
  end

  describe 'invalid response' do
    context 'when non-existent siren raise 404', vcr: { cassette_name: 'acoss/with_non_existent_siren' } do
      let(:siren) { non_existent_siren }

      its(:http_code) { is_expected.to eq(404) }
      its(:errors) { is_expected.to have_error("Siren invalide, l'ACOSS ne peut délivrer d'attestation (erreur: Le siren est inconnu du SI Attestations, radié ou hors périmètre Code d'erreur ACOSS : FUNC517)") }
    end

    describe 'with stub requests' do
      let(:siren) { valid_siren(:acoss) }
      let(:stub_response) do
        {
          status: 200,
          body: body&.to_json
        }
      end

      before do
        allow(request).to receive(:token).and_return('dummy token')
        stub_request(:post, /urssaf.+entreprise/).to_return(stub_response)
      end

      context 'when ACOSS returns an empty body' do
        let(:body) { nil }

        its(:http_code) { is_expected.to eq 502 }
        its(:errors) { is_expected.to have_error("L'ACOSS a répondu avec une erreur non supportée (erreur: ACOSS request failed due to empty body)") }

        include_examples 'provider\'s response error'
      end

      context 'when ACOSS returns a body with multiple errors, including a 503' do
        let(:body) do
          [
            { code: 'FUNC501', message: 'Message 501', description: 'description 1' },
            { code: 'FUNC502', message: 'Message 502', description: 'description 2' }
          ]
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:errors) { is_expected.to have_error("Siren invalide, l'ACOSS ne peut délivrer d'attestation (erreur: description 1 Code d'erreur ACOSS : FUNC501)") }
        its(:errors) { is_expected.to have_error("L'ACOSS ne peut répondre à votre requête, réessayez ultérieurement (erreur: description 2)") }

        include_examples 'provider\'s response error'

        it 'sets provider_error_custom_code as concatenation of all error codes' do
          expect(subject.provider_error_custom_code).to eq('FUNC501 FUNC502')
        end
      end

      context 'when ACOSS returns a body with multiple errors, but only 404' do
        let(:body) do
          [
            { code: 'FUNC501', message: 'Message 501', description: 'description 1' },
            { code: 'FUNC517', message: 'Message 517', description: 'description 17' }
          ]
        end

        its(:http_code) { is_expected.to eq 404 }
      end

      context 'when ACOSS returns an error hash instead of an array (which produces a TypeError)' do
        let(:body) do
          {
            oki: 'wtf?'
          }
        end

        before do
          allow(MonitoringService.instance).to receive(:track_provider_error_from_response)
        end

        its(:http_code) { is_expected.to eq 502 }
        its(:errors) { is_expected.to have_error("L'ACOSS a répondu avec une erreur non supportée (erreur: ACOSS request failed due to unexpected body)") }

        include_examples 'provider\'s response error'

        context 'when it is an internal payload with detail->msgId' do
          let(:body) do
            {
              details: {
                msgId: "Id-a89e5f6104153603807d93ba",
              }
            }
          end

          it 'does not log this error' do
            expect(Sentry).not_to receive(:capture_message).with(
              'Wrong payload from ACOSS (originaly reported in 1895733)'
            )

            subject
          end
        end

        context 'when it is another random error' do
          it 'logs this specific error for future investigation (not documented)' do
            expect(Sentry).to receive(:set_extras).with({
              body: body
            })
            expect(Sentry).to receive(:capture_message).with(
              'Wrong payload from ACOSS (originaly reported in 1895733)'
            )

            subject
          end
        end
      end
    end
  end

  describe 'happy path', vcr: { cassette_name: 'acoss/with_valid_siren' } do
    context 'when siren is valid' do
      let(:siren) { valid_siren(:acoss) }

      its(:http_code) { is_expected.to eq(200) }
      its(:errors) { is_expected.to be_empty }
    end
  end
end
