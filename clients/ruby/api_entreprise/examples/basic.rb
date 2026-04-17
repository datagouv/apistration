#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Basic happy path against staging.
#   TOKEN=$(curl -s https://raw.githubusercontent.com/datagouv/apistration/develop/mocks/tokens/default)
#   API_ENTREPRISE_TOKEN=$TOKEN bundle exec ruby examples/basic.rb

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'api_entreprise'

client = ApiEntreprise::Client.new(
  environment: :staging,
  default_params: {
    recipient: '13002526500013',
    context:   'Exemple SDK',
    object:    'Démonstration'
  }
)

response = client.insee.unites_legales('418166096')

puts "status:    #{response.http_status}"
puts "provider:  #{response.meta['provider']}"
puts "remaining: #{response.rate_limit&.remaining}"
puts "siren:     #{response.data&.dig('siren')}"
puts "denomination: #{response.data&.dig('personne_morale_attributs', 'raison_sociale')}"
