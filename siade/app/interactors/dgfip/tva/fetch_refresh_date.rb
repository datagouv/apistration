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

    JSON.parse(response.body)['last_modified']
  rescue StandardError
    nil
  end

  def resource_id
    Siade.credentials[:dgfip_tva_resource_id]
  end
end
