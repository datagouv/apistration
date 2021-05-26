RSpec.describe SIADE::V2::Responses::Generic do
  before(:all) do
    class SIADE::V2::Responses::DummyResponse < SIADE::V2::Responses::Generic
      def adapt_raw_response_code
        if raw_response.extra_context
          add_context_to_provider_error_tracking(raw_response.extra_context)
        end

        raw_response.code
      end
    end
  end

  subject { SIADE::V2::Responses::DummyResponse.new(raw_response) }

  let(:raw_response) do
    OpenStruct.new(
      body:          '',
      code:          code,
      extra_context: extra_context,
    )
  end

  let(:extra_context) { nil }

  context 'when http status is OK' do
    let(:code) { 200 }

    it 'does not track error' do
      expect(MonitoringService.instance).not_to receive(:track_provider_error_from_response)

      subject
    end
  end

  context 'when http status is a 5XX (server error)' do
    let(:code) { 502 }

    it 'tracks error' do
      expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
        instance_of(SIADE::V2::Responses::DummyResponse),
        {},
      )

      subject
    end

    context 'when there is extra context to track' do
      let(:extra_context) do
        {
          custom_code:    '042',
          custom_message: 'PANIK',
        }
      end

      it 'adds this context to tracking' do
        expect(MonitoringService.instance).to receive(:track_provider_error_from_response).with(
          instance_of(SIADE::V2::Responses::DummyResponse),
          extra_context,
        )

        subject
      end
    end
  end
end
