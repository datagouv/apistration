require 'yaml'
require 'json'
require 'net/http'
require 'openssl'
require 'colorize'

# Check README for usage

@host = ARGV[0] || "https://entreprise.api.gouv.fr"
@endpoints = !ARGV[1].nil? ? ARGV[1].split(',').map(&:to_i) : []
@only_v3 = ENV.fetch('ONLY_V3', false)

if @host =~ /sandbox/
  token_to_read = '.token.sandbox'
elsif @host =~ /staging/
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
  context:   'Test',
  recipient: '13002526500013',
  object:    'Pré mise en production',
}
@request_options = {
  use_ssl:     true,
  verify_mode: OpenSSL::SSL::VERIFY_PEER,
}

endpoints = File.read("#{File.dirname(__FILE__)}/../config/endpoints_with_test_case.yml")

def test_endpoint(endpoint, index)
  name = endpoint['name']
  route = endpoint['http_path']

  uri = URI("#{@host}#{route}").tap do |u|
    query_params = @default_query_params.dup

    if endpoint['extra_http_query']
      query_params.merge!(endpoint['extra_http_query'])
    end

    u.query = URI.encode_www_form(query_params)
  end

  response = Net::HTTP.start(uri.hostname, uri.port, @request_options) do |http|
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@jwt}".gsub("\n", '')

    http.read_timeout = 30
    http.open_timeout = 30

    http.request request
  end

  if response.code == '200'
    status = "OK".green
  elsif response.code == '401'
    print "Token is not valid for this host! Abort.\n".red
    exit 2
  else
    status = "NOK ( #{response.code} )".red
  end
rescue Net::ReadTimeout
  status = "NOK ( timeout from client )".red
ensure
  print "[#{index}] Endpoint '#{name}' ( #{route} ): #{status}\n"

  if ENV['DEBUG']
    print "Payload:\n"
    begin
      print JSON.pretty_generate(JSON.parse(response.body))
    rescue JSON::ParserError
      print "#{response.body}\n"
    end
  end
end

print "## Test endpoints on #{@host}\n\n"

YAML.load(endpoints).each_with_index do |endpoint, index|
  next if @only_v3 && !endpoint['name'].include?('V3')

  if @endpoints.empty? || @endpoints.include?(index+1)
    test_endpoint(endpoint, index+1)
    sleep 1 unless @host =~ /staging/
  end
end
