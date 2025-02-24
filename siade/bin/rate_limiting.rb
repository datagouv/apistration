require 'net/http'
require 'openssl'
require 'colorize'
require 'byebug'

host = ARGV[0] || "https://entreprise.api.gouv.fr"

endpoints = {
  json_resources_entreprise: {
    url: '/v4/djepva/api-association/associations/775719792',
    limit: 250,
  },
  low_latency_docs: {
    url: '/v2/certificats_cnetp/542036207',
    limit: 50,
  },
  high_latency_documents: {
    url: '/v3/dgfip/unites_legales/532010576/attestation_fiscale',
    limit: 5,
  },
}

if host =~ /sandbox/
  token_to_read = '.token.sandbox'
elsif host =~ /staging/
  token_to_read = '.token.staging'
else
  token_to_read = '.token.production'
end

begin
  @jwt = File.read(token_to_read)
rescue Errno::ENOENT
  begin
    @jwt = File.read('.token')
  rescue Errno::ENOENT
    print ".token or #{token_to_read} should exists\n"
    exit 1
  end
end

@default_query_params = {
  context: 'Test rate limiting',
  recipient: 'DINUM - API Entreprise',
  object: 'Pré mise en production',
}

@request_options = {
  use_ssl: true,
  verify_mode: OpenSSL::SSL::VERIFY_PEER,
}

def make_call(kind, endpoint)
  uri = URI(endpoint).tap do |u|
    query_params = @default_query_params.dup

    if endpoint['extra_http_query']
      query_params.merge!(endpoint['extra_http_query'])
    end

    u.query = URI.encode_www_form(query_params)
  end

  response = Net::HTTP.start(uri.hostname, uri.port, @request_options) do |http|
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@jwt}".gsub("\n", '')
    http.request request
  end

  if response.code == '200'
    status = "OK".green
  elsif response.code == '401'
    print "Token is not valid for this host! Abort.\n".red
    exit 2
  elsif response.code == '500'
    print "Internal error. Abort.\n".red
    exit 2
  else
    status = "NOK ( #{response.code} )".red
  end

  print "Endpoint #{endpoint} ( #{kind} ): #{status}\n"
  print "Headers RateLimit:\n"

  %w[Limit Remaining Reset].each do |subkey|
    print "#{subkey}: #{response["RateLimit-#{subkey}"]}\n"
  end
  print "Retry-After: #{response['Retry-After']}\n"
  print "\n"
end

endpoints.each do |kind, endpoint_data|
  (endpoint_data[:limit] + 1).times do
    make_call(kind, "#{host}/#{endpoint_data[:url]}")
  end
end
