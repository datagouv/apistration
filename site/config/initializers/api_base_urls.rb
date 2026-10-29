module APIEntreprise
  BASE_URL = if Rails.env.sandbox?
               'https://sandbox.entreprise.api.gouv.fr'
             elsif Rails.env.staging? || Rails.env.development?
               'https://staging.entreprise.api.gouv.fr'
             else
               'https://entreprise.api.gouv.fr'
             end

  ERRORS_NOMENCLATURE_URL = "#{BASE_URL}/v3/errors".freeze
  PINGS_URL = "#{BASE_URL}/pings".freeze
end

module APIParticulier
  BASE_URL = if Rails.env.sandbox?
               'https://sandbox.particulier.api.gouv.fr'
             elsif Rails.env.staging? || Rails.env.development?
               'https://staging.particulier.api.gouv.fr'
             else
               'https://particulier.api.gouv.fr'
             end

  ERRORS_NOMENCLATURE_URL = "#{BASE_URL}/api/errors".freeze
  PINGS_URL = "#{BASE_URL}/api/pings".freeze
end
