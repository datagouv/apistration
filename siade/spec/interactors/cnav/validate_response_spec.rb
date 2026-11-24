RSpec.describe CNAV::ValidateResponse, type: :validate_response do
  subject { described_class.call(response:, provider_name: 'Sécurité sociale') }

  context 'with 200 response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 200, body:)
    end

    context 'with valid body' do
      let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/make_request_valid.json') }

      it { is_expected.to be_a_success }

      its(:errors) { is_expected.to be_empty }
    end

    context 'with invalid body' do
      let(:body) { 'lol' }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
    end
  end

  context 'with not found response' do
    context 'with sub provider error' do
      context 'with SNGI error, which translate an identity not found' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:)
        end

        let(:body) { read_payload_file('cnav/404-identity-not-found.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnprocessableEntityError)) }

        it 'returns a SNGI error carrying the queried provider' do
          expect(subject.errors.first.code).to eq('36560')
          expect(subject.errors.first.detail).to include('Les paramètres fournis ne permettent pas')
          expect(subject.errors.first.meta).to eq(provider: 'Sécurité sociale')
        end

        it 'attests nothing, since the person was not identified' do
          expect(subject.errors.first.attestation).to be_nil
        end
      end

      context 'with RNCPS 404 error, which translate a regime not found' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:)
        end

        let(:body) { read_payload_file('cnav/404-regime-not-found.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns a RNCPS error' do
          expect(subject.errors.first.detail).to include('éligibles')
        end

        it 'states the RNCPS as the origin of the answer' do
          expect(subject.errors.first.meta).to include(origin: 'RNCPS')
        end

        it 'attests a consultation without result' do
          expect(subject.errors.first.attestation).to eq(:no_result)
        end
      end
    end

    context 'with regime error' do
      context 'with CNAF regime' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '00810011' })
        end

        let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns a CNAF error, which translates to an identity found but not within regimes' do
          expect(subject.errors.first.detail).to include('CNAF')
        end

        it 'states the CNAF as the origin of the answer' do
          expect(subject.errors.first.meta).to include(origin: 'CNAF')
        end

        it 'attests a consultation without result' do
          expect(subject.errors.first.attestation).to eq(:no_result)
        end
      end

      context 'with MSA regime' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '00171001' })
        end

        let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns an MSA error, which translates to an identity found but not within regimes' do
          expect(subject.errors.first.detail).to include('MSA')
        end

        it 'states the MSA as the origin of the answer' do
          expect(subject.errors.first.meta).to include(origin: 'MSA')
        end

        it 'attests a consultation without result' do
          expect(subject.errors.first.attestation).to eq(:no_result)
        end
      end

      context 'with RNCPS regime' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '99430000' })
        end

        let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(NotFoundError)) }

        it 'returns a RNCPS error' do
          expect(subject.errors.first.detail).to include('RNCPS')
        end

        it 'states the RNCPS as the origin of the answer' do
          expect(subject.errors.first.meta).to include(origin: 'RNCPS')
        end

        it 'attests nothing' do
          expect(subject.errors.first.attestation).to be_nil
        end
      end
    end

    context 'with unknown provider' do
      let(:response) do
        instance_double(Net::HTTPNotFound, code: 404, body:, header: {})
      end

      let(:body) { read_payload_file('cnav/complementaire_sante_solidaire/404.json') }

      it { is_expected.to be_a_failure }

      its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

      it 'returns a provider unknown error' do
        expect(subject.errors.first.detail).to include('Une erreur inattendue est survenue lors de la collecte des données')
      end
    end

    context 'with an HTML error page from the gateway instead of JSON' do
      let(:body) { '<html><head><title>Error</title></head><body>Not Found</body></html>' }

      context 'without regime header' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: {})
        end

        it { is_expected.to be_a_failure }

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
      end

      context 'with a regime header' do
        let(:response) do
          instance_double(Net::HTTPNotFound, code: 404, body:, header: { 'X-APISECU-FD' => '00810011' })
        end

        its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }

        it 'does not attest the absence of the file' do
          expect(subject.errors.first.attestation).to be_nil
        end
      end
    end
  end

  context 'with 500 http code response' do
    subject { described_class.call(response:, provider_name: 'Sécurité sociale', dss_prestation_name: 'allocation_adulte_handicape') }

    let(:response) do
      instance_double(Net::HTTPInternalServerError, code: 500, body: '{"error":"Erreur technique non spécifiée","errorCode":50001}', header: { 'X-APISECU-FD' => '99430000' })
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderInternalServerError)) }

    it 'attests nothing, since the provider gave no answer about the person' do
      expect(subject.errors.first.attestation).to be_nil
    end

    it 'tags the event with the provider error code and the regime' do
      expect(MonitoringService.instance).to receive(:set_tags).with(cnav_error_code: '50001', regime: 'RNCPS')

      subject
    end

    it 'tracks warning with response context and encrypted params, fingerprinted by prestation and provider error code' do
      expect(MonitoringService.instance).to receive(:track_with_added_context).with(
        'warning',
        '[Sécurité sociale] Internal server error (50001)',
        hash_including(:http_response_code, :http_response_body, :encrypted_params),
        fingerprint: %w[cnav-internal-server-error allocation_adulte_handicape 50001]
      )

      subject
    end

    it 'carries the DSS error code in the error meta, without its free-form message' do
      expect(subject.errors.first.meta).to eq(
        provider: 'Sécurité sociale',
        provider_error_code: 50_001
      )
    end

    it 'logs the DSS error code in the access logs' do
      RenderedError.capture(subject.errors)

      expect(RenderedError.log_fields).to include(provider_error_code: '50001')
    end

    context 'when the gateway fails on a connection reset, without DSS error code' do
      let(:response) do
        instance_double(Net::HTTPInternalServerError, code: 500, body: '{"Exception":"API Gateway encountered an error. Error Message - java.net.SocketException: Connection reset. Service - API_Prestations, Operation - /AEEH/details"}', header: {})
      end

      it 'carries the connection reset cause in the error meta, without the raw exception' do
        expect(subject.errors.first.meta).to eq(
          provider: 'Sécurité sociale',
          provider_error_code: 'http_500_connection_reset'
        )
      end

      it 'logs the connection reset cause in the access logs' do
        RenderedError.capture(subject.errors)

        expect(RenderedError.log_fields).to include(provider_error_code: 'http_500_connection_reset')
      end
    end

    context 'when the gateway fails on another exception, without DSS error code' do
      let(:response) do
        instance_double(Net::HTTPInternalServerError, code: 500, body: '{"Exception":"API Gateway encountered an error. Error Message - java.net.SocketTimeoutException: Read timed out"}', header: {})
      end

      it 'carries a generic gateway exception cause in the error meta' do
        expect(subject.errors.first.meta).to include(provider_error_code: 'http_500_gateway_exception')
      end

      it 'names the fallback cause in the tracked message' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'warning',
          '[Sécurité sociale] Internal server error (http_500_gateway_exception)',
          anything,
          anything
        )

        subject
      end
    end

    context 'when DSS answers with an HTML page' do
      let(:response) do
        instance_double(Net::HTTPInternalServerError, code: 500, body: '<html><body><h1>Internal Server Error</h1></body></html>', header: {})
      end

      it { is_expected.to be_a_failure }

      it 'logs the HTTP status as provider error code in the access logs' do
        RenderedError.capture(subject.errors)

        expect(RenderedError.log_fields).to include(provider_error_code: 'http_500')
      end
    end
  end

  context 'with random http code response' do
    let(:response) do
      instance_double(Net::HTTPOK, code: 401)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnknownError)) }
  end

  context 'with 429 http code response' do
    let(:response) do
      instance_double(Net::HTTPTooManyRequests, code: 429)
    end

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderRateLimitingError)) }
  end

  context 'with 400 http code response' do
    let(:response) do
      instance_double(Net::HTTPBadRequest, code: 400, body:, header: {})
    end
    let(:body) { '{"errorCode":40013,"error":"Format de la commune de naissance erroné"}' }

    it { is_expected.to be_a_failure }

    its(:errors) { is_expected.to include(instance_of(ProviderUnprocessableEntityError)) }

    it 'tracks a gateway input control as info, fingerprinted by provider error code, with encrypted params' do
      expect(MonitoringService.instance).to receive(:track_with_added_context).with(
        'info',
        '[Sécurité sociale] Bad request (40013)',
        hash_including(:http_response_code, :http_response_body, :regime, :encrypted_params),
        fingerprint: %w[cnav-bad-request 40013]
      )

      subject
    end

    context 'with the identity params' do
      subject do
        described_class.call(
          response:,
          provider_name: 'Sécurité sociale',
          params: { nom_naissance: "D'ARC", nom_usage: 'DU LAC 2', prenoms: ['JEANNE'], code_cog_insee_commune_naissance: '00123' }
        )
      end

      it 'describes their shape in the event, so the refused format can be read without decrypting them' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'info',
          '[Sécurité sociale] Bad request (40013)',
          hash_including(
            params_shape: {
              nom_naissance: '5:apostrophe',
              nom_usage: '8:inner_space,digit',
              prenoms: '6:',
              code_cog_insee_commune_naissance: '5:00'
            }
          ),
          fingerprint: %w[cnav-bad-request 40013]
        )

        subject
      end
    end

    it 'tags the event with the provider error code, without the regime the gateway did not name' do
      expect(MonitoringService.instance).to receive(:set_tags).with(cnav_error_code: '40013')

      subject
    end

    it 'includes the provider and its error code and message in meta' do
      expect(subject.errors.first.meta).to eq(
        provider: 'Sécurité sociale',
        provider_error_code: 40_013,
        provider_error_message: 'Format de la commune de naissance erroné'
      )
    end

    context 'with another error code' do
      let(:body) { '{"errorCode":40014,"error":"Code Sexe absent"}' }

      it 'tracks under a distinct fingerprint' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'info',
          '[Sécurité sociale] Bad request (40014)',
          anything,
          fingerprint: %w[cnav-bad-request 40014]
        )

        subject
      end
    end

    context 'with a code that should never reach us (40002, name absent)' do
      let(:body) { '{"errorCode":40002,"error":"Nom de naissance ou nom d\'usage absent"}' }

      it 'tracks as error' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'error',
          '[Sécurité sociale] Bad request (40002)',
          anything,
          fingerprint: %w[cnav-bad-request 40002]
        )

        subject
      end
    end

    context 'with an HTML error page from the gateway instead of JSON' do
      let(:body) { '<html><head><title>Error</title></head><body>Bad Request</body></html>' }

      it 'reports an unknown provider response instead of rejecting the civility' do
        expect(subject.errors).to include(instance_of(ProviderUnknownError))
      end
    end

    context 'with a gateway exception, without DSS error code' do
      let(:body) { '{"Exception":"API Gateway encountered an error. Error Message:  Native service provider error. Code : 400. Request Details: Service - API_Prestations, Operation - /AAH/details"}' }

      it 'reports an unknown provider response instead of rejecting the civility' do
        expect(subject.errors).to contain_exactly(instance_of(ProviderUnknownError))
      end

      it 'names the gateway exception in the tracked message and fingerprint' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'error',
          '[Sécurité sociale] Bad request (http_400_gateway_exception)',
          anything,
          fingerprint: %w[cnav-bad-request http_400_gateway_exception]
        )

        subject
      end
    end

    context 'with a code out of the CNAV error table' do
      let(:body) { '{"errorCode":40099,"error":"?"}' }

      it 'tracks as error' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'error',
          '[Sécurité sociale] Bad request (40099)',
          anything,
          fingerprint: %w[cnav-bad-request 40099]
        )

        subject
      end
    end

    context 'with a failure of the family provider (40000)' do
      let(:body) { '{"errorCode":40000,"error":"RESSOURCE INCONNUE, CALCUL QF IMPOSSIBLE"}' }

      it 'reports a provider internal error instead of rejecting the civility, keeping the provider error in meta' do
        error = subject.errors.first

        expect(error).to be_an_instance_of(ProviderInternalServerError)
        expect(error.meta).to eq(
          provider: 'Sécurité sociale',
          provider_error_code: 40_000,
          provider_error_message: 'RESSOURCE INCONNUE, CALCUL QF IMPOSSIBLE'
        )
      end

      it 'tracks it as warning' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'warning',
          '[Sécurité sociale] Bad request (40000)',
          anything,
          fingerprint: %w[cnav-bad-request 40000]
        )

        subject
      end
    end

    context 'with an unparseable body' do
      let(:body) { 'lol' }

      it 'tracks under an unparseable fingerprint' do
        expect(MonitoringService.instance).to receive(:track_with_added_context).with(
          'error',
          '[Sécurité sociale] Bad request (unparseable)',
          anything,
          fingerprint: %w[cnav-bad-request unparseable]
        )

        subject
      end
    end
  end
end
