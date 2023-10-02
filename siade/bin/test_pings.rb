ENV['RAILS_ENV'] = 'production'

ping_config = Rails.application.config_for(:pings)

def test_ping(url)
  response = Net::HTTP.get_response(URI(url))

  print "#{url}: "
  if response.code == '200'
    puts 'OK'.green
  else
    puts "ERROR #{response.code}".red
  end
end

def base_url(service)
  {
    'api_entreprise' => 'https://entreprise.api.gouv.fr/ping/%{identifier}',
    'api_particulier' => 'https://particulier.api.gouv.fr/api/%{identifier}/ping',
  }.fetch(service.to_s)
end

%i[api_entreprise api_particulier].each do |service|
  print "# Testing #{service}... \n"
  ping_config[service].each do |ping_name, _config|
    url = base_url(service) % { identifier: ping_name }

    test_ping(url)
  end
end
