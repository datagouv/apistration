RSpec.describe ProviderResponseSpy do
  it 'logs one http code' do
    expect(ActiveSupport::Notifications).to receive(:instrument).with('provider_http_code', provider_name: 'provider name', http_code: 500)
    described_class.log_http_code(provider_name: 'provider name', http_code: 500)
  end
end
