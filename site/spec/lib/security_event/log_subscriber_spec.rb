require 'rails_helper'

RSpec.describe SecurityEvent::LogSubscriber do
  subject(:emit) { described_class.new.emit(event) }

  let(:event) { { name: SecurityEvent::NOTIFICATION_NAME, payload:, context: {} } }
  let(:payload) do
    {
      event: 'auth.session.closed',
      actor: { email: 'user@example.com', role: 'user' },
      target: { type: 'user', id: 'user-id' },
      details: { reason: 'logout' }
    }
  end
  let(:logstash_output) { StringIO.new }
  let(:dedicated_line) { JSON.parse(logstash_output.string) }

  before do
    RequestStore.clear!
    allow(LogStasher).to receive(:logger).and_return(logstash_output)
  end

  after { RequestStore.clear! }

  context 'when emitted while a controller action is processed' do
    before { described_class.open_request_line }

    it 'appends the event to the request logstash line' do
      emit
      described_class.new.emit(event)

      expect(LogStasher.store[:security_events]).to eq([payload, payload])
    end

    it 'does not write a dedicated line' do
      emit

      expect(logstash_output.string).to be_empty
    end
  end

  context 'when emitted after the request logstash line was written' do
    before do
      described_class.open_request_line
      described_class.close_request_line
    end

    it 'writes a dedicated logstash line instead of losing the event' do
      emit

      expect(dedicated_line['security_events']).to eq([payload.deep_stringify_keys])
    end
  end

  context 'when another action is processed in the same request, like an error page' do
    it 'does not log the events of the previous action again' do
      described_class.open_request_line
      emit
      described_class.close_request_line
      described_class.open_request_line

      expect(LogStasher.store).not_to have_key(:security_events)
    end
  end

  context 'when emitted outside a request' do
    it 'writes a dedicated logstash line' do
      emit

      expect(dedicated_line).to include(
        'type' => 'admin',
        'tags' => ['security_event'],
        'security_events' => [payload.deep_stringify_keys]
      )
    end
  end
end
