#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Opt-in retry middleware demo for api_particulier.

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'api_particulier'
require 'webmock'
include WebMock::API
WebMock.enable!
WebMock.disable_net_connect!

BASE = 'https://staging.particulier.api.gouv.fr'
PATH = '/v3/ants/extrait_immatriculation_vehicule/france_connect'

stub_request(:get, %r{#{BASE}#{PATH}})
  .to_return(
    { status: 503, headers: { 'Content-Type' => 'application/json' },
      body: { errors: [{ code: '05000', title: 't', detail: 'down' }] }.to_json },
    { status: 200, headers: { 'Content-Type' => 'application/json' },
      body: { data: { 'plate' => 'AA-123-BB' }, links: {}, meta: {} }.to_json }
  )

client = ApiParticulier::Client.new(
  token: 't',
  environment: :staging,
  default_params: { recipient: '13002526500013' },
  retry: { max: 2, on_status: [429, 502, 503], interval: 0.1 }
)

response = client.ants.extrait_immatriculation_vehicule(immatriculation: 'AA-123-BB')
puts "Final status: #{response.http_status}"
puts "Data: #{response.data.inspect}"
