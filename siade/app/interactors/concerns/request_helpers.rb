module RequestHelpers
  def current_host
    "https://#{Rails.env}.entreprise.api.gouv.fr"
  end
end
