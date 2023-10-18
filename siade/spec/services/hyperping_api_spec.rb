RSpec.describe HyperpingAPI, type: :service do
  let(:monitor_response) do
    {
      'name' => 'My monitor',
      'url' => 'https://example.com'
    }
  end

  describe '#get_monitors' do
    subject { described_class.new.get_monitors }

    let!(:stubbed_request) do
      stub_request(:get, 'https://api.hyperping.io/api/v1/monitors')
        .with(
          headers: {
            'Authorization' => "Bearer #{Siade.credentials[:hyperping_api_key]}"
          }
        )
        .to_return(status: 200, body: { monitors: [monitor_response] }.to_json, headers: {})
    end

    it 'calls the Hyperping API' do
      subject

      expect(stubbed_request).to have_been_requested
    end

    it 'returns an array' do
      expect(subject).to eq({ 'monitors' => [monitor_response] })
    end
  end

  describe '#create_monitor' do
    subject { described_class.new.create_monitor(monitor_params) }

    let(:monitor_params) do
      {
        name: 'My monitor',
        url: 'https://example.com'
      }
    end

    let!(:stubbed_request) do
      stub_request(:post, 'https://api.hyperping.io/api/v1/monitors')
        .with(
          body: monitor_params.to_json,
          headers: {
            'Authorization' => "Bearer #{Siade.credentials[:hyperping_api_key]}",
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: monitor_response.to_json, headers: {})
    end

    it 'calls the Hyperping API' do
      subject

      expect(stubbed_request).to have_been_requested
    end

    it 'returns the monitor' do
      expect(subject).to eq(monitor_response)
    end
  end

  describe '#update_monitor' do
    subject { described_class.new.update_monitor(monitor_id, monitor_params) }

    let(:monitor_id) { 123 }
    let(:monitor_params) do
      {
        name: 'My monitor',
        url: 'https://example.com'
      }
    end

    let!(:stubbed_request) do
      stub_request(:put, "https://api.hyperping.io/api/v1/monitors/#{monitor_id}")
        .with(
          body: monitor_params.to_json,
          headers: {
            'Authorization' => "Bearer #{Siade.credentials[:hyperping_api_key]}",
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: monitor_response.to_json, headers: {})
    end

    it 'calls the Hyperping API' do
      subject

      expect(stubbed_request).to have_been_requested
    end

    it 'returns the monitor' do
      expect(subject).to eq(monitor_response)
    end
  end
end
