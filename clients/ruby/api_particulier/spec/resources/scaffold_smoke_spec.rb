RSpec.describe 'Generated resources smoke test' do
  let(:client) do
    ApiParticulier::Client.new(
      token: 't',
      environment: :staging,
      default_params: { recipient: '13002526500013' }
    )
  end

  providers = %i[ants cnous dsnj dss france_travail gip_mds men mesri sdh]

  providers.each do |provider|
    it "exposes #{provider} and its resource has methods" do
      resource = client.public_send(provider)
      expect(resource).to be_a(ApiParticulier::Resources.const_get(provider.to_s.split('_').map(&:capitalize).join))
      expect(resource.public_methods(false)).not_to be_empty
    end
  end
end
