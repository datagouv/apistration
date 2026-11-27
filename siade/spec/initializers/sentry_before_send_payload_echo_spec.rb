RSpec.describe Sentry, '#before_send payload echo' do
  subject(:sent_event) { JSON.parse(JSON.generate(described_class.configuration.before_send.call(event, {}).to_h)) }

  let(:client) { Sentry::Client.new(described_class.configuration) }
  let(:event) { client.event_from_exception(exception) }

  before do
    Rails.cache.clear
    allow(described_class.configuration).to receive(:sending_allowed?).and_return(true)
    allow(DataEncryptor).to receive(:new).and_return(instance_double(DataEncryptor, encrypt: 'ENCRYPTED'))
  end

  def sent_messages
    sent_event.dig('exception', 'values').pluck('value').join("\n") + sent_event['contexts'].to_s
  end

  def raised(&)
    yield
  rescue StandardError => e
    e
  end

  context 'when a provider answers JSON that does not parse' do
    let(:exception) { raised { JSON.parse('{"nom":DUPONT,"prenom":"JEAN","dateNaissance":"1980-01-01"}') } }

    it 'does not send the quoted payload in clear' do
      expect(sent_messages).not_to include('DUPONT', 'JEAN')
    end

    it 'keeps the exception type and sends the message encrypted' do
      expect(sent_event.dig('exception', 'values', 0, 'type')).to eq('JSON::ParserError')
      expect(sent_event.dig('contexts', 'Parse error 1', 'encrypted_message')).to eq('ENCRYPTED')
    end
  end

  context 'when the parse error is the cause of another exception' do
    let(:exception) do
      raised do
        JSON.parse('{"nom":DUPONT}')
      rescue JSON::ParserError
        raise 'invalid provider payload'
      end
    end

    it 'does not send the quoted payload in clear, and keeps the outer message' do
      expect(sent_messages).not_to include('DUPONT')
      expect(sent_messages).to include('invalid provider payload')
    end
  end

  context 'when the exception does not quote any payload' do
    let(:exception) { raised { raise 'provider timeout' } }

    it 'sends its message as is' do
      expect(sent_event.dig('exception', 'values', 0, 'value')).to eq('provider timeout (RuntimeError)')
    end
  end
end
