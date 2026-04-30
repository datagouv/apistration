#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Opt-in retry middleware: retries 429/502/503 with backoff, respects retry_after.
# Demonstrated with a stubbed HTTP layer (3 consecutive 502, then a 200).
#
#   bundle exec ruby examples/retry.rb

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'api_entreprise'
require 'webmock'
include WebMock::API
WebMock.enable!
WebMock.disable_net_connect!

BASE = 'https://staging.entreprise.api.gouv.fr'
PATH = '/v3/insee/sirene/unites_legales/418166096'

stub_request(:get, %r{#{BASE}#{PATH}})
  .to_return(
    { status: 502, headers: { 'Content-Type' => 'application/json' },
      body: { errors: [{ code: '04001', title: 't', detail: 'provider KO' }] }.to_json },
    { status: 502, headers: { 'Content-Type' => 'application/json' },
      body: { errors: [{ code: '04001', title: 't', detail: 'provider KO' }] }.to_json },
    { status: 200, headers: { 'Content-Type' => 'application/json' },
      body: { data: { 'siren' => '418166096' }, links: {}, meta: {} }.to_json }
  )

client = ApiEntreprise::Client.new(
  token: 't',
  environment: :staging,
  default_params: { recipient: '13002526500013', context: 'retry', object: 'retry' },
  retry: { max: 3, on_status: [429, 502, 503], interval: 0.1, backoff_factor: 2 }
)

response = client.insee.unites_legales('418166096')
puts "Final status: #{response.http_status}"
puts "Data: #{response.data.inspect}"
