RSpec.describe ApiEntreprise::Client do
  let(:default_params) do
    { recipient: '13002526500013', context: 'Calcul aide', object: 'Dossier 42' }
  end

  describe 'configuration precedence' do
    it 'reads the token from API_ENTREPRISE_TOKEN when no arg is given' do
      ENV['API_ENTREPRISE_TOKEN'] = 'env-token'
      begin
        c = described_class.new(environment: :staging, default_params: default_params)
        stub = stub_request(:get, %r{staging\.entreprise\.api\.gouv\.fr/v4/insee/sirene/unites_legales/418166096})
               .with(headers: { 'Authorization' => 'Bearer env-token' })
               .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                          body: { data: {}, links: {}, meta: {} }.to_json)
        c.insee.unites_legales('418166096')
        expect(stub).to have_been_requested
      ensure
        ENV.delete('API_ENTREPRISE_TOKEN')
      end
    end

    it 'explicit token argument wins over ENV' do
      ENV['API_ENTREPRISE_TOKEN'] = 'env-token'
      begin
        c = described_class.new(token: 'arg-token', environment: :staging, default_params: default_params)
        stub = stub_request(:get, %r{staging\.entreprise\.api\.gouv\.fr/v4/insee/sirene/unites_legales/418166096})
               .with(headers: { 'Authorization' => 'Bearer arg-token' })
               .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                          body: { data: {}, links: {}, meta: {} }.to_json)
        c.insee.unites_legales('418166096')
        expect(stub).to have_been_requested
      ensure
        ENV.delete('API_ENTREPRISE_TOKEN')
      end
    end

    it 'reads the base_url from API_ENTREPRISE_BASE_URL' do
      ENV['API_ENTREPRISE_BASE_URL'] = 'https://gateway.test'
      begin
        c = described_class.new(token: 't')
        expect(c.configuration.base_url).to eq('https://gateway.test')
      ensure
        ENV.delete('API_ENTREPRISE_BASE_URL')
      end
    end
  end

  describe 'user agent' do
    it 'sets a User-Agent matching §10 format on every request' do
      client = described_class.new(token: 't', environment: :staging, default_params: default_params)
      stub = stub_request(:get, %r{/v4/insee/sirene/unites_legales/418166096})
             .with(headers: {
                     'User-Agent' => %r{\Aapi-entreprise-ruby/\d+\.\d+\.\d+ \(\+https://github\.com/datagouv/apistration\)\z}
                   })
             .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                        body: { data: {}, links: {}, meta: {} }.to_json)
      client.insee.unites_legales('418166096')
      expect(stub).to have_been_requested
    end
  end

  describe 'environments' do
    it 'defaults to production URL' do
      c = described_class.new(token: 't')
      expect(c.configuration.base_url).to eq('https://entreprise.api.gouv.fr')
    end

    it 'switches to staging URL' do
      c = described_class.new(token: 't', environment: :staging)
      expect(c.configuration.base_url).to eq('https://staging.entreprise.api.gouv.fr')
    end

    it 'honours base_url override' do
      c = described_class.new(token: 't', base_url: 'https://custom.test')
      expect(c.configuration.base_url).to eq('https://custom.test')
    end
  end

  describe 'end-to-end contract (§12.2)' do
    let(:client) do
      described_class.new(token: 't', environment: :staging, default_params: default_params)
    end

    def stub_staging(path, status:, body:, headers: {})
      stub_request(:get, "https://staging.entreprise.api.gouv.fr#{path}")
        .with(query: hash_including('recipient' => '13002526500013'),
              headers: { 'Authorization' => 'Bearer t' })
        .to_return(status: status,
                   headers: { 'Content-Type' => 'application/json' }.merge(headers),
                   body: body.to_json)
    end

    it '200 with data/links/meta envelope and RateLimit-* parsed' do
      stub_staging('/v4/insee/sirene/unites_legales/418166096',
                   status: 200,
                   headers: { 'RateLimit-Limit' => '50', 'RateLimit-Remaining' => '49', 'RateLimit-Reset' => '1700000000' },
                   body: { data: { 'siren' => '418166096' }, links: {}, meta: { 'provider' => 'INSEE' } })
      r = client.insee.unites_legales('418166096')
      expect(r.http_status).to eq(200)
      expect(r.data['siren']).to eq('418166096')
      expect(r.rate_limit.remaining).to eq(49)
    end

    it '422 raises ValidationError' do
      stub_staging('/v4/insee/sirene/unites_legales/418166096',
                   status: 422,
                   body: { errors: [{ code: '00301', title: 'Entité non traitable', detail: 'siren invalide', source: { parameter: 'siren' }, meta: {} }] })
      expect { client.insee.unites_legales('418166096') }
        .to raise_error(ApiEntreprise::Commons::ValidationError, /siren invalide/)
    end

    it '429 raises RateLimitError with retry_after populated' do
      stub_staging('/v4/insee/sirene/unites_legales/418166096',
                   status: 429,
                   headers: { 'RateLimit-Reset' => (Time.now.to_i + 17).to_s },
                   body: { errors: [{ code: '00429', title: 't', detail: 'd', meta: {} }] })
      begin
        client.insee.unites_legales('418166096')
      rescue ApiEntreprise::Commons::RateLimitError => e
        expect(e.retry_after).to be_between(14, 20).inclusive
      end
    end

    it '502 raises ProviderError with meta.retry_in surfaced' do
      stub_staging('/v4/insee/sirene/unites_legales/418166096',
                   status: 502,
                   body: { errors: [{ code: '04001', title: 't', detail: 'd', meta: { retry_in: 300 } }] })
      begin
        client.insee.unites_legales('418166096')
      rescue ApiEntreprise::Commons::ProviderError => e
        expect(e.retry_after).to eq(300)
      end
    end
  end

  describe 'local validation' do
    it 'rejects a bad SIREN before any HTTP call' do
      client = described_class.new(token: 't', default_params: default_params)
      expect { client.insee.unites_legales('bogus') }
        .to raise_error(ApiEntreprise::Commons::InvalidSirenError)
      expect(a_request(:get, /.+/)).not_to have_been_made
    end

    it 'rejects a bad recipient SIRET before any HTTP call' do
      client = described_class.new(token: 't',
                                   default_params: default_params.merge(recipient: '13002526500014'))
      expect { client.insee.unites_legales('418166096') }
        .to raise_error(ApiEntreprise::Commons::InvalidSiretError)
      expect(a_request(:get, /.+/)).not_to have_been_made
    end
  end
end
