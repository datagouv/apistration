class DGFIP::TVA::FetchRefreshDate < ApplicationInteractor
  CACHE_KEY = 'dgfip_tva_refresh_date'.freeze
  CACHE_TTL = 1.hour

  def call
    context.date_derniere_mise_a_jour = Rails.cache.fetch(CACHE_KEY, expires_in: CACHE_TTL) do
      fetch_from_api
    end
  end

  private

  def fetch_from_api
    uri = URI("https://www.data.gouv.fr/api/2/datasets/resources/#{resource_id}/")
    response = Net::HTTP.get_response(uri)
    return nil unless response.is_a?(Net::HTTPOK)

    Date.parse(JSON.parse(response.body).dig('resource', 'last_modified')).iso8601
  rescue StandardError
    nil
  end

  def resource_id
    DGFIP::TVA::MakeRequest::RESOURCE_ID
  end
end
