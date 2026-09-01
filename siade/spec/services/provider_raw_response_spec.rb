require 'rails_helper'

RSpec.describe ProviderRawResponse do
  subject(:raw_response) { described_class.new(response) }

  context 'with a Net::HTTP response' do
    let(:response) do
      Net::HTTPNotFound.new('1.1', '404', 'Not Found').tap do |net_response|
        net_response['Content-Type'] = 'application/json'
        net_response.instance_variable_set(:@body, '{"message":"nope"}')
        net_response.instance_variable_set(:@read, true)
      end
    end

    it 'extracts status, headers and base64 body' do
      expect(raw_response.as_meta).to eq(
        'status' => 404,
        'headers' => { 'content-type' => 'application/json' },
        'body_base64' => Base64.strict_encode64('{"message":"nope"}')
      )
    end
  end

  context 'with a response duck typing headers and status' do
    let(:response) do
      OpenStruct.new(
        headers: { 'Content-Type' => 'application/json' },
        body: '{"message":"tea"}',
        status: 418
      )
    end

    it 'extracts the debugging log payload' do
      expect(raw_response.as_debugging_log).to eq(
        header: { 'Content-Type' => 'application/json' },
        body: Base64.strict_encode64('{"message":"tea"}'),
        status: 418
      )
    end
  end

  context 'with a response without headers nor status' do
    let(:response) { OpenStruct.new(body: 'whatever') }

    it 'falls back on empty values' do
      expect(raw_response.as_meta).to eq(
        'status' => nil,
        'headers' => {},
        'body_base64' => Base64.strict_encode64('whatever')
      )
    end
  end
end
