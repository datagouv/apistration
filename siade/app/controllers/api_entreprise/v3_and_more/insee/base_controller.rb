class APIEntreprise::V3AndMore::INSEE::BaseController < APIEntreprise::V3AndMore::BaseController
  protected

  def retrieve_payload_data(organizer, cache: true, expires_in: 1.hour)
    super
  end
end
