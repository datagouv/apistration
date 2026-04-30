RSpec.describe 'Deprecated endpoint annotation' do
  def build_client
    ApiEntreprise::Client.new(
      token: 't',
      environment: :staging,
      default_params: { recipient: '13002526500013', context: 'c', object: 'o' }
    )
  end

  it 'defaults to the latest available version (v4 for insee.unites_legales)' do
    v4_stub = stub_request(:get, %r{https://staging\.entreprise\.api\.gouv\.fr/v4/insee/sirene/unites_legales/418166096})
              .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                         body: { data: {}, links: {}, meta: {} }.to_json)
    build_client.insee.unites_legales('418166096')
    expect(v4_stub).to have_been_requested
  end

  it 'emits a deprecation warning when pinning to a deprecated version' do
    stub_request(:get, %r{https://staging\.entreprise\.api\.gouv\.fr/v3/insee/sirene/unites_legales/418166096})
      .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                 body: { data: {}, links: {}, meta: {} }.to_json)
    expect { build_client.insee.unites_legales('418166096', version: 3) }
      .to output(/\[DEPRECATED\].*unites_legales/).to_stderr
  end

  it 'honours an older pinned version' do
    v3_stub = stub_request(:get, %r{https://staging\.entreprise\.api\.gouv\.fr/v3/insee/sirene/unites_legales/418166096})
              .to_return(status: 200, headers: { 'Content-Type' => 'application/json' },
                         body: { data: {}, links: {}, meta: {} }.to_json)
    build_client.insee.unites_legales('418166096', version: 3)
    expect(v3_stub).to have_been_requested
  end

  it 'raises ArgumentError on an unsupported version' do
    expect { build_client.insee.unites_legales('418166096', version: 99) }
      .to raise_error(ArgumentError, /version 99.*supported/)
  end
end

RSpec.describe 'Generated resources smoke test' do
  let(:client) do
    ApiEntreprise::Client.new(
      token: 't',
      environment: :staging,
      default_params: { recipient: '13002526500013', context: 'c', object: 'o' }
    )
  end

  providers = %i[
    ademe banque_de_france carif_oref cibtp cma_france cnetp data_subvention dgfip
    douanes european_commission fabrique_numerique_ministeres_sociaux fntp gip_mds
    infogreffe inpi insee ministere_interieur msa opqibi probtp qualibat qualifelec
    urssaf
  ]

  providers.each do |provider|
    it "exposes #{provider} and instantiates its resource" do
      resource = client.public_send(provider)
      expect(resource).to be_a(ApiEntreprise::Resources.const_get(provider.to_s.split('_').map(&:capitalize).join))
      expect(resource.public_methods(false)).not_to be_empty
    end
  end
end
