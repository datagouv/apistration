RSpec.describe Sentry, '#before_send encoding' do
  subject(:before_send) { described_class.configuration.before_send }

  let(:client) { Sentry::Client.new(described_class.configuration) }

  before do
    Rails.cache.clear
    allow(described_class.configuration).to receive(:sending_allowed?).and_return(true)
  end

  def event_with_provider_body(body)
    client.event_from_message('[Sécurité sociale] Internal server error (50001)').tap do |event|
      event.contexts = { 'Extra context' => { http_response_body: body, encrypted_params: 'gpg' } }
    end
  end

  def sent_body(event)
    sent_event = before_send.call(event, {})
    JSON.parse(JSON.generate(sent_event.to_h)).dig('contexts', 'Extra context', 'http_response_body')
  end

  it 'sends a provider body received as binary UTF-8, accents kept' do
    expect(sent_body(event_with_provider_body('{"message": "Données indisponibles"}'.b)))
      .to eq('{"message": "Données indisponibles"}')
  end

  it 'sends a provider body received as binary Latin-1, translated to UTF-8' do
    expect(sent_body(event_with_provider_body("{\"message\": \"Donn\xE9es indisponibles\"}".b)))
      .to eq('{"message": "Données indisponibles"}')
  end

  it 'sends a body tagged UTF-8 with invalid bytes, only those bytes replaced' do
    body = "{\"message\": \"Données \xFF indisponibles\"}".dup.force_encoding(Encoding::UTF_8)

    expect(sent_body(event_with_provider_body(body))).to eq('{"message": "Données � indisponibles"}')
  end

  it 'sends a message, extra and tags received as binary' do
    event = client.event_from_message("Deprecated data for field 'nom'. Value: Andr\xE9".b)
    event.extra = { body: 'Données'.b }
    event.tags = { provider: 'Sécurité sociale'.b }

    sent_event = JSON.parse(JSON.generate(before_send.call(event, {}).to_h))

    expect(sent_event['message']).to eq("Deprecated data for field 'nom'. Value: André")
    expect(sent_event.dig('extra', 'body')).to eq('Données')
    expect(sent_event.dig('tags', 'provider')).to eq('Sécurité sociale')
  end

  it 'leaves a valid UTF-8 event unchanged' do
    contexts = { 'Extra context' => { http_response_body: '{"message": "Données"}', status: 500, codes: [1, nil] } }
    event = client.event_from_message('Internal server error')
    event.contexts = contexts.deep_dup

    expect(before_send.call(event, {}).contexts).to eq(contexts)
  end
end
