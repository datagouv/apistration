RSpec.describe Sentry, '#before_send rate limit' do
  subject(:before_send) { described_class.configuration.before_send }

  let(:client) { Sentry::Client.new(described_class.configuration) }

  before do
    Rails.cache.clear
    allow(described_class.configuration).to receive(:sending_allowed?).and_return(true)
  end

  def exception_event(klass)
    client.event_from_exception(klass.new('boom'))
  end

  def send_event(event)
    before_send.call(event, {})
  end

  def exhaust_cap(event)
    5_000.times { send_event(event) }
  end

  it 'keeps sending events of a type when another type without fingerprint exhausted its cap' do
    exhaust_cap(exception_event(ArgumentError))

    expect(send_event(exception_event(KeyError))).to be_present
  end

  it 'drops events of a type beyond 5 000 in the hour, while other types still go through' do
    exhaust_cap(exception_event(ArgumentError))

    expect(send_event(exception_event(ArgumentError))).to be_nil
    expect(send_event(exception_event(KeyError))).to be_present
  end

  it 'counts messages without fingerprint separately from each other' do
    exhaust_cap(client.event_from_message('Bad request'))

    expect(send_event(client.event_from_message('Internal server error'))).to be_present
  end

  it 'keeps sending events when the counter store is unavailable' do
    allow(Rails.cache).to receive(:increment).and_return(nil)

    expect(send_event(exception_event(ArgumentError))).to be_present
  end
end
