#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Basic happy path against staging.
#   TOKEN=$(curl -s https://raw.githubusercontent.com/datagouv/apistration/develop/mocks/tokens/default)
#   API_PARTICULIER_TOKEN=$TOKEN bundle exec ruby examples/basic.rb

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'api_particulier'

client = ApiParticulier::Client.new(
  environment: :staging,
  default_params: { recipient: '13002526500013' }
)

response = client.ants.extrait_immatriculation_vehicule(immatriculation: 'AA-123-BB')

puts "status:    #{response.http_status}"
puts "remaining: #{response.rate_limit&.remaining}"
puts "data keys: #{response.data&.keys.inspect}"
