require 'faraday'

class DatagouvAPIClient
  def find_dataservice(id)
    http_connection.get("#{host}/api/1/dataservices/#{id}/").body
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
    ENV.fetch('DATAGOUV_HOST')
  end

  def token
    ENV.fetch('DATAGOUV_API_TOKEN')
  end

  def http_connection(&block)
    Faraday.new do |conn|
      conn.headers['X-API-KEY'] = token
      conn.headers['Content-Type'] = 'application/json'
      conn.request :retry, max: 2
      conn.response :raise_error
      conn.response :json
      conn.options.timeout = 5
      yield(conn) if block
    end
  end
end
