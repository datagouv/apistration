#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Same pattern as api_entreprise/examples/error_handling.rb, adapted to the
# Particulier client. No network required.

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'api_particulier'
require 'webmock'
include WebMock::API
WebMock.enable!
WebMock.disable_net_connect!

BASE = 'https://staging.particulier.api.gouv.fr'
PATH = '/v3/ants/extrait_immatriculation_vehicule/france_connect'

client = ApiParticulier::Client.new(
  token: 't',
  environment: :staging,
  default_params: { recipient: '13002526500013' }
)

def show(label)
  yield
rescue ApiParticulier::Commons::Error => e
  puts "#{label.ljust(30)} -> #{e.class.name.split('::').last} " \
       "(status=#{e.http_status}, code=#{e.first_error_code})"
rescue ArgumentError => e
  puts "#{label.ljust(30)} -> #{e.class.name.split('::').last} (#{e.message.split("\n").first})"
end

[401, 403, 404, 422, 429, 502, 503].each do |status|
  WebMock.reset!
  stub_request(:get, %r{#{BASE}#{PATH}}).to_return(
    status: status,
    headers: { 'Content-Type' => 'application/json' },
    body: { errors: [{ code: '00001', title: 't', detail: "status=#{status}" }] }.to_json
  )
  show("HTTP #{status}") { client.ants.extrait_immatriculation_vehicule(immatriculation: 'AA-123-BB') }
end

# Local validation — no HTTP.
show('local: missing recipient') do
  ApiParticulier::Client.new(token: 't')
                        .ants.extrait_immatriculation_vehicule(immatriculation: 'AA-123-BB')
end
