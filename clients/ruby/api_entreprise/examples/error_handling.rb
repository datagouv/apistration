#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Exercises every branch of the exception hierarchy with a stubbed HTTP layer.
# No network required.
#
#   bundle exec ruby examples/error_handling.rb

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'api_entreprise'
require 'webmock'
include WebMock::API
WebMock.enable!
WebMock.disable_net_connect!

BASE = 'https://staging.entreprise.api.gouv.fr'
PATH = '/v3/insee/sirene/unites_legales/418166096'

def show(label)
  yield
rescue ApiEntreprise::Commons::Error => e
  puts "#{label.ljust(30)} -> #{e.class.name.split('::').last} " \
       "(status=#{e.http_status}, code=#{e.first_error_code}, detail=#{e.first_error_detail})"
rescue ArgumentError => e
  puts "#{label.ljust(30)} -> #{e.class.name.split('::').last} (#{e.message.split("\n").first})"
end

client = ApiEntreprise::Client.new(
  token: 't',
  environment: :staging,
  default_params: { recipient: '13002526500013', context: 'ex', object: 'ex' }
)

fixtures = {
  401 => { code: '00101', title: 'Invalide', detail: 'Token invalide' },
  403 => { code: '00100', title: 'Forbidden', detail: 'Privilèges insuffisants' },
  404 => { code: '04040', title: 'Not found', detail: 'SIREN introuvable' },
  409 => { code: '00015', title: 'Conflict', detail: 'Doublon en cours' },
  422 => { code: '00301', title: 'Invalid', detail: 'siren malformé' },
  429 => { code: '00429', title: 'Rate', detail: 'Trop de requêtes' },
  502 => { code: '04001', title: 'Provider', detail: 'Fournisseur KO', meta: { retry_in: 300 } },
  503 => { code: '05000', title: 'Unavailable', detail: 'Maintenance' }
}

fixtures.each do |status, err|
  WebMock.reset!
  stub_request(:get, %r{#{BASE}#{PATH}}).to_return(
    status: status,
    headers: { 'Content-Type' => 'application/json' },
    body: { errors: [err] }.to_json
  )
  show("HTTP #{status}") { client.insee.unites_legales('418166096') }
end

# RateLimitError#retry_after from RateLimit-Reset:
WebMock.reset!
stub_request(:get, %r{#{BASE}#{PATH}}).to_return(
  status: 429,
  headers: { 'Content-Type' => 'application/json',
             'RateLimit-Reset' => (Time.now.to_i + 30).to_s },
  body: { errors: [{ code: '00429', title: 't', detail: 'd', meta: {} }] }.to_json
)
begin
  client.insee.unites_legales('418166096')
rescue ApiEntreprise::Commons::RateLimitError => e
  puts "#{'429 with Reset'.ljust(30)} -> retry_after=#{e.retry_after}s"
end

# Local validation, no HTTP at all:
show('local: bad SIREN') { client.insee.unites_legales('not-a-siren') }
show('local: bad recipient SIRET') do
  bad = ApiEntreprise::Client.new(token: 't',
                                  default_params: { recipient: '13002526500014',
                                                    context: 'c', object: 'o' })
  bad.insee.unites_legales('418166096')
end
