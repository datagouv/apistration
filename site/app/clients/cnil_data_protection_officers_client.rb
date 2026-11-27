require 'faraday'

class CnilDataProtectionOfficersClient
  DATA_URL = 'https://tabular-api.data.gouv.fr/api/resources/c5d02b42-1008-4406-83f5-3a81c8b936a3/data/'.freeze

  def latest_designation(siren)
    http_connection.get(DATA_URL, {
      'SIREN organisme désignant__exact' => siren,
      'Date de la désignation__sort' => 'desc',
      'page_size' => 1
    }).body['data'].first
  end

  private

  def http_connection
    Faraday.new do |conn|
      conn.response :raise_error
      conn.response :json
      conn.options.timeout = 3
    end
  end
end
