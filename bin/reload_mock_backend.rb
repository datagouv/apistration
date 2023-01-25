require 'net/http'
require 'json'
require 'byebug'

call = Net::HTTP.post(URI.parse('https://staging.particulier.api.gouv.fr/api/reload-mocks'), '')

if call.response.code == '200'
  print JSON.parse(call.body)['message']
  exit 0
else
  print "Error: #{call.response.code} | Body: #{call.body}"
  exit 1
end
