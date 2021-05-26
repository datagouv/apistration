RSpec.shared_examples 'provider\'s response error' do
  it 'tracks provider\'s response error in monitoring service' do
    expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
      instance_of(described_class),
      anything,
    ).at_least(1)

    subject
  end
end
