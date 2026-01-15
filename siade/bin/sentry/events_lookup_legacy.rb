require File.expand_path('../config/application', __dir__)

require 'faraday'
require 'yaml'
require 'byebug'
require 'csv'
require 'gpgme'
require_relative '../app/services/data_encryptor'

base_uri = 'https://errors.data.gouv.fr'
token = File.read('.sentry_token').strip

def api_particulier?(event)
  event['context']['params']['controller'].include?('api_particulier')
end

if token.nil?
  print ".sentry_token is missing, please create a token with `event:read` scope here: https://errors.data.gouv.fr/settings/account/api/auth-tokens/\n"
  exit 1
end

issue_id = ARGV[0]

if issue_id.nil?
  print "Usage: bin/sentry_events_lookup.rb <issue_id>\n"
  exit 1
end

page_count = ARGV.fetch(1, 1).to_i

print "Extracting events for issue #{issue_id} for #{page_count} pages...\n"

select_condition = lambda do |event|
  # event['context']['http_response_code'] == '400' &&
  #   event['context']['http_response_body'].include?('au serveur ADELIE est mal')
  return true unless api_particulier?(event)

  encrypted_params = event['context']['encrypted_params']

  return false if encrypted_params.nil?
  return false if encrypted_params == '[Filtered]'

  true
end

to_extract = lambda do |event|
  hash = {
    http_status: event['context']['http_response_code'],
    http_body: event['context']['http_response_body'],
    date: event['dateCreated']
  }.compact

  if event['context']['params']['controller'].include?('api_particulier') && !event['context']['encrypted_params'].nil?
    encrypted_params = event['context']['encrypted_params']

    begin
      hash[:params] = EncryptData.new(encrypted_params).decrypt
    rescue StandardError
      byebug
    end
  elsif event['context']['params']['controller'].include?('api_entreprise')
    hash[:params] = event['context']['params']
  end

  hash
end

final_data = []

http_connection = Faraday.new do |conn|
  conn.response :raise_error
  conn.response :json
  conn.options.open_timeout = 30
  conn.options.timeout = 30
  conn.request :authorization, 'Bearer', token
end

page_count.times do |page|
  response = http_connection.get(
    "#{base_uri}/api/0/issues/#{issue_id}/events/",
    {
      full: false,
      cursor: "0:0:#{page * 100}"
    }
  )

  valid_events = response.body.select do |event|
    select_condition.call(event)
  end

  final_data |= valid_events.map { |event|
    to_extract.call(event)
  }.dup
end

final_data.uniq!

final_data.each do |data|
  data.each do |key, value|
    data[key] = value.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')
  end
end

if final_data.empty?
  print "No data.. skipping\n"
  exit 1
end

filename = "tmp/issues_#{issue_id}.csv"

CSV.open(filename, 'wb:UTF-8') do |csv|
  csv << final_data.first.keys

  final_data.each do |data|
    csv << data.values
  end
end

print "Done\nSaved to #{filename}\n"
