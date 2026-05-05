RSpec.describe ApiParticulier::Client do
  let(:default_params) { { recipient: '13002526500013' } }

  describe 'environments' do
    it 'defaults to production URL' do
      c = described_class.new(token: 't')
      expect(c.configuration.base_url).to eq('https://particulier.api.gouv.fr')
    end

    it 'switches to staging URL' do
      c = described_class.new(token: 't', environment: :staging)
      expect(c.configuration.base_url).to eq('https://staging.particulier.api.gouv.fr')
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
      stub_request(:get, "https://staging.particulier.api.gouv.fr#{path}")
        .with(query: hash_including('recipient' => '13002526500013'),
              headers: { 'Authorization' => 'Bearer t' })
        .to_return(status: status,
                   headers: { 'Content-Type' => 'application/json' }.merge(headers),
                   body: body.to_json)
    end

    it '200 envelope + rate-limit parsed' do
      stub_staging('/v3/ants/extrait_immatriculation_vehicule/france_connect',
                   status: 200,
                   headers: { 'RateLimit-Remaining' => '49' },
                   body: { data: { 'immat' => 'AA-123-BB' }, links: {}, meta: {} })
      r = client.ants.extrait_immatriculation_vehicule(immatriculation: 'AA-123-BB')
      expect(r.data['immat']).to eq('AA-123-BB')
      expect(r.rate_limit.remaining).to eq(49)
    end

    it '422 raises ValidationError' do
      stub_staging('/v3/ants/extrait_immatriculation_vehicule/france_connect',
                   status: 422,
                   body: { errors: [{ code: '00201', title: 't', detail: 'd', meta: {} }] })
      expect { client.ants.extrait_immatriculation_vehicule(immatriculation: 'x') }
        .to raise_error(ApiParticulier::Commons::ValidationError)
    end

    it '429 populates retry_after' do
      stub_staging('/v3/ants/extrait_immatriculation_vehicule/france_connect',
                   status: 429,
                   headers: { 'RateLimit-Reset' => (Time.now.to_i + 11).to_s },
                   body: { errors: [{ code: '00429', title: 't', detail: 'd', meta: {} }] })
      begin
        client.ants.extrait_immatriculation_vehicule(immatriculation: 'x')
      rescue ApiParticulier::Commons::RateLimitError => e
        expect(e.retry_after).to be_between(8, 14).inclusive
      end
    end

    it '502 surfaces meta.retry_in on ProviderError' do
      stub_staging('/v3/ants/extrait_immatriculation_vehicule/france_connect',
                   status: 502,
                   body: { errors: [{ code: '04001', title: 't', detail: 'd', meta: { retry_in: 60 } }] })
      begin
        client.ants.extrait_immatriculation_vehicule(immatriculation: 'x')
      rescue ApiParticulier::Commons::ProviderError => e
        expect(e.retry_after).to eq(60)
      end
    end
  end

  describe 'local validation' do
    it 'rejects a bad recipient SIRET before any HTTP call' do
      bad = described_class.new(token: 't', default_params: { recipient: '13002526500014' })
      expect { bad.ants.extrait_immatriculation_vehicule(immatriculation: 'x') }
        .to raise_error(ApiParticulier::Commons::InvalidSiretError)
      expect(a_request(:get, /.+/)).not_to have_been_made
    end

    it 'requires recipient' do
      barebone = described_class.new(token: 't')
      expect { barebone.ants.extrait_immatriculation_vehicule(immatriculation: 'x') }
        .to raise_error(ApiParticulier::Commons::MissingParameterError, /recipient/)
      expect(a_request(:get, /.+/)).not_to have_been_made
    end
  end
end
