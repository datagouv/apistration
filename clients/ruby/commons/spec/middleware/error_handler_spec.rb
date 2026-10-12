RSpec.describe 'ErrorHandler middleware' do
  let(:client) { TestClientSupport.build_client }

  def stub_error(status, errors:, headers: {}, **top_level)
    stub_request(:get, 'https://example.test/v3/foo')
      .with(query: hash_including('recipient' => '13002526500013'))
      .to_return(status: status,
                 headers: { 'Content-Type' => 'application/json' }.merge(headers),
                 body: { errors: errors }.merge(top_level).to_json)
  end

  matrix = [
    [401, '00101', ApiGouvCommons::AuthenticationError],
    [401, '00103', ApiGouvCommons::AuthenticationError],
    [401, '00105', ApiGouvCommons::AuthenticationError],
    [403, '00100', ApiGouvCommons::AuthorizationError],
    [404, '04040', ApiGouvCommons::NotFoundError],
    [409, '00015', ApiGouvCommons::ConflictError],
    [422, '00201', ApiGouvCommons::ValidationError],
    [422, '00301', ApiGouvCommons::ValidationError],
    [502, '04001', ApiGouvCommons::ProviderError],
    [503, '05000', ApiGouvCommons::ProviderUnavailableError],
    [418, 'any', ApiGouvCommons::ClientError],
    [599, 'any', ApiGouvCommons::ServerError]
  ]

  matrix.each do |status, code, klass|
    it "maps #{status}/#{code} to #{klass}" do
      stub_error(status, errors: [{ code: code, title: 't', detail: 'd' }])

      expect { client.get('/v3/foo') }.to raise_error(klass) do |e|
        expect(e.http_status).to eq(status)
        expect(e.first_error_code).to eq(code)
        expect(e.first_error_detail).to eq('d')
        expect(e.method).to eq(:get)
        expect(e.url).to include('/v3/foo')
      end
    end
  end

  describe 'top-level meta and links of an error body' do
    let(:not_found) { [{ code: '35003', title: 'Allocataire non référencé', detail: 'd' }] }
    let(:proof_meta) do
      { 'verification_url' => 'https://particulier.api.gouv.fr/attestations/verification/t', 'verification_code' => 'ABCD-EF01-23' }
    end
    let(:proof_links) { { 'attestation_pdf' => 'https://particulier.api.gouv.fr/api/attestations/t.pdf' } }

    shared_examples 'an error without meta nor links' do
      it 'leaves meta and links nil' do
        expect { client.get('/v3/foo') }.to raise_error(ApiGouvCommons::NotFoundError) do |e|
          expect(e.meta).to be_nil
          expect(e.links).to be_nil
        end
      end
    end

    context 'when a 404 carries a proof' do
      before { stub_error(404, errors: not_found, meta: proof_meta, links: proof_links) }

      it 'exposes them on the error' do
        expect { client.get('/v3/foo') }.to raise_error(ApiGouvCommons::NotFoundError) do |e|
          expect(e.meta).to eq(proof_meta)
          expect(e.links).to eq(proof_links)
        end
      end
    end

    context 'when the body has none' do
      before { stub_error(404, errors: not_found) }

      it_behaves_like 'an error without meta nor links'
    end

    context 'when they are not objects' do
      before { stub_error(404, errors: not_found, meta: 'unexpected', links: ['unexpected']) }

      it_behaves_like 'an error without meta nor links'
    end
  end

  it 'wraps Faraday::ConnectionFailed as TransportError' do
    stub_request(:get, 'https://example.test/v3/foo')
      .with(query: hash_including('recipient' => '13002526500013'))
      .to_raise(Errno::ECONNREFUSED)
    expect { client.get('/v3/foo') }.to raise_error(ApiGouvCommons::TransportError)
  end

  describe 'RateLimitError.retry_after' do
    it 'derives from RateLimit-Reset' do
      stub_error(429,
                 errors: [{ code: '00429', title: 't', detail: 'd', meta: {} }],
                 headers: { 'RateLimit-Reset' => (Time.now.to_i + 42).to_s })
      begin
        client.get('/v3/foo')
      rescue ApiGouvCommons::RateLimitError => e
        expect(e.retry_after).to be_between(40, 44).inclusive
      end
    end

    it 'falls back to meta.retry_in when no reset header' do
      stub_error(429, errors: [{ code: '00429', title: 't', detail: 'd', meta: { retry_in: 7 } }])
      begin
        client.get('/v3/foo')
      rescue ApiGouvCommons::RateLimitError => e
        expect(e.retry_after).to eq(7)
      end
    end
  end

  it 'surfaces meta.retry_in on ProviderError (502)' do
    stub_error(502, errors: [{ code: '04001', title: 't', detail: 'd', meta: { retry_in: 300 } }])
    begin
      client.get('/v3/foo')
    rescue ApiGouvCommons::ProviderError => e
      expect(e.retry_after).to eq(300)
    end
  end
end
