RSpec.describe SIADE::V2::Responses::AbstractProviderError, type: :provider_response do
  subject { SIADE::V2::Responses::DummyProviderError.new(provider_name, exception) }

  before(:all) do
    class SIADE::V2::Responses::DummyProviderError < SIADE::V2::Responses::AbstractProviderError
      def error
        @error ||= InvalidTokenError.new
      end

      def http_code
        502
      end
    end
  end

  let(:provider_name) { 'Dummy provider' }

  before do
    allow(MonitoringService.instance).to receive(:track_provider_error_from_response).and_call_original
  end

  context 'without exception' do
    let(:exception) { nil }

    it 'tracks provider error' do
      expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
        instance_of(SIADE::V2::Responses::DummyProviderError),
        nil
      )

      subject
    end
  end

  context 'with exception' do
    let(:exception) do
      1 / 0
    rescue StandardError => e
      e
    end

    it 'adds exception inspect and backtrace in monitoring context' do
      expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
        instance_of(SIADE::V2::Responses::DummyProviderError),
        {
          exception_inspect: exception.inspect,
          exception_backtrace: exception.backtrace
        }
      )

      subject
    end
  end
end
