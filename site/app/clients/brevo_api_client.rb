require 'faraday'

class BrevoAPIClient
  BASE_URL = 'https://api.brevo.com/v3'.freeze

  def upsert_contact(email:, attributes:, list_ids:)
    http_connection.post(
      "#{BASE_URL}/contacts",
      {
        email:,
        attributes:,
        listIds: list_ids,
        updateEnabled: true
      }.to_json
    )
  end

  def subscribe_with_double_optin(email:, list_ids:, template_id:, redirection_url:)
    http_connection.post(
      "#{BASE_URL}/contacts/doubleOptinConfirmation",
      { email:, includeListIds: list_ids, templateId: template_id, redirectionUrl: redirection_url }.to_json
    )
  end

  private

  def http_connection
    Faraday.new do |conn|
      conn.headers['api-key'] = AdminApientreprise.credentials[:brevo_api_key]
      conn.headers['Content-Type'] = 'application/json'
      conn.headers['Accept'] = 'application/json'
      conn.response :raise_error
      conn.options.timeout = 5
    end
  end
end
