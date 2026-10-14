require 'rails_helper'

RSpec.describe 'Logstash request line' do
  subject(:request_login_page) do
    get '/compte/se-connecter', env: { 'REMOTE_ADDR' => '203.0.113.4' }, headers: { 'User-Agent' => 'Mozilla/5.0 Test' }
  end

  let(:logstash_output) { StringIO.new }
  let(:logstash_line) { JSON.parse(logstash_output.string.lines.last) }

  before do
    host! 'entreprise.api.localtest.me'
    allow(LogStasher).to receive(:logger).and_return(Logger.new(logstash_output))
  end

  it 'logs the client IP in clear for the SIEM' do
    request_login_page

    expect(logstash_line['ip']).to eq('203.0.113.4')
  end

  it 'logs the raw user agent' do
    request_login_page

    expect(logstash_line['user_agent_raw']).to eq('Mozilla/5.0 Test')
  end

  it 'keeps hashing the IP everywhere else' do
    get '/compte/se-connecter', env: { 'REMOTE_ADDR' => '203.0.113.4' }

    expect(request.remote_ip).not_to eq('203.0.113.4')
  end
end
