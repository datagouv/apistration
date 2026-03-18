RSpec.describe ELKResponseSpy do
  it 'raises an ActiveSupport::Notification with the right infos' do
    expect(ActiveSupport::Notifications).to receive(:instrument).with('response', provider_name: 'sirene', fallback_used: true)
    described_class.log_fallback_usage(provider_name: 'sirene', fallback_used: true)
  end
end
