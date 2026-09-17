class INSEEPasswordRenewal
  RENEWAL_URL = 'https://api.insee.fr/api-sirene/prive/3.11/renouvellement'.freeze
  TIMEOUT = 5

  def renew(token:, old_password:, new_password:)
    http_connection.post(RENEWAL_URL) do |request|
      request.headers['Authorization'] = "Bearer #{token}"
      request.headers['Content-Type'] = 'application/json'
      request.body = { oldPassword: old_password, newPassword: new_password }.to_json
    end
  end

  private

  def http_connection
    @http_connection ||= Faraday.new do |conn|
      conn.options.timeout = TIMEOUT
    end
  end
end
