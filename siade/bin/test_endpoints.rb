require 'optparse'
require 'yaml'
require 'json'
require 'net/http'
require 'openssl'
require 'colorize'

# Check README for usage
options = {}

valid_hosts = %w[
  main
  production1
  production2
  staging1
  staging2
  staging
  sandbox
  sandbox1
  sandbox2
]

OptionParser.new do |opts|
  opts.banner = "Usage: ruby test_rate_limiting.rb [options]"

  opts.on("-h", "--host host", "Host to test, default to main host") do |host|
    if valid_hosts.include?(host)
      options[:host] = host
    else
      puts "Invalid host, valid hosts are: #{valid_hosts.join(', ')}"
      exit 1
    end
  end

  opts.on("-i", "--indexes indexes", "Indexes of endpoints to test, default to all") do |indexes|
    options[:indexes] = indexes.split(',').map do |index|
      index.to_i
    end.uniq
  end
end.parse!

@host = options[:host] || 'main'

if @host =~ /sandbox/
  token_to_read = '.token.sandbox'
elsif @host =~ /staging/
  token_to_read = '.token.staging'
else
  token_to_read = '.token.production'
end

begin
  @jwt = File.read(token_to_read).gsub("\n", '')
rescue Errno::ENOENT
  print "#{token_to_read} should exists\nUse ./bin/generate_jwt_token.rb to generate one\n"
  exit 2
end

@request_options = {
  use_ssl:     true,
  verify_mode: OpenSSL::SSL::VERIFY_PEER,
}

endpoints = File.read("#{File.dirname(__FILE__)}/../config/endpoints_with_test_case.yml")

def make_call(endpoint)
  api_kind = endpoint['api']

  if api_kind == 'entreprise'
    uri = URI("#{full_host_url(api_kind)}#{endpoint['path']}").tap do |u|
      query_params = {
        context:   'Test',
        recipient: '13002526500013',
        object:    'Pré mise en production',
      }

      u.query = URI.encode_www_form(query_params)
    end

    response = Net::HTTP.start(uri.hostname, uri.port, @request_options) do |http|
      request = Net::HTTP::Get.new(uri)

      request['Authorization'] = "Bearer #{@jwt}"
      request['Cache-Control'] = 'no-cache'

      http.read_timeout = 30
      http.open_timeout = 30

      http.request request
    end
  elsif api_kind == 'particulier'
    uri = URI("#{full_host_url(api_kind)}#{endpoint['path']}").tap do |u|
      u.query = URI.encode_www_form(endpoint['query_params']) if endpoint['query_params']
    end

    response = Net::HTTP.start(uri.hostname, uri.port, @request_options) do |http|
      request = Net::HTTP::Get.new(uri)

      request['X-Api-Key'] = @jwt
      request['Cache-Control'] = 'no-cache'

      http.read_timeout = 30
      http.open_timeout = 30

      http.request request
    end
  else
    raise "Unknown api kind #{api_kind}"
  end
end

def full_host_url(api_kind)
  case @host
  when 'main'
    "https://#{api_kind}.api.gouv.fr"
  else
    "https://#{@host}.#{api_kind}.api.gouv.fr"
  end
end

def test_endpoint(endpoint, index)
  response = make_call(endpoint)

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
  endpoint_name = "[API #{endpoint['api']}] #{endpoint['name']}"
  print "[#{format("%02d",index)}] Endpoint '#{endpoint_name}' ( #{endpoint['path']} ): #{status}\n"

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
  next if options[:indexes] && !options[:indexes].include?(index + 1)

  test_endpoint(endpoint, index+1)
  sleep 1 unless @host =~ /staging/
end
