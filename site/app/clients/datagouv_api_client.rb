require 'faraday'
require 'faraday/follow_redirects'

class DatagouvAPIClient
  def list_dataservices(organization:)
    dataservices = []
    page = 1

    loop do
      response = http_connection.get("#{host}/api/1/dataservices/", { organization: organization, page: page, page_size: 100 }).body
      dataservices.concat(response['data'])
      break if response['next_page'].blank?

      page += 1
    end

    dataservices
  end

  def create_dataservice(payload)
    http_connection.post("#{host}/api/1/dataservices/", payload.to_json).body
  end

  def update_dataservice(id, payload)
    http_connection.patch("#{host}/api/1/dataservices/#{id}/", payload.to_json).body
  end

  def delete_dataservice(id)
    http_connection.delete("#{host}/api/1/dataservices/#{id}/")
    nil
  end

  private

  def host
    AdminApientreprise.credentials[:datagouv_host]
  end

  def token
    AdminApientreprise.credentials[:datagouv_api_token]
  end

  def http_connection(&block)
    Faraday.new do |conn|
      conn.headers['X-API-KEY'] = token
      conn.headers['Content-Type'] = 'application/json'
      conn.request :retry, max: 2
      conn.response :raise_error
      conn.response :json
      conn.response :follow_redirects, standards_compliant: true
      conn.options.timeout = 5
      yield(conn) if block
    end
  end
end
