module APIEntreprise
  BASE_URL = if Rails.env.sandbox?
               'https://sandbox.entreprise.api.gouv.fr'
             elsif Rails.env.staging? || Rails.env.development?
               'https://staging.entreprise.api.gouv.fr'
             else
               'https://entreprise.api.gouv.fr'
             end
end

module APIParticulier
  BASE_URL = if Rails.env.sandbox?
               'https://sandbox.particulier.api.gouv.fr'
             elsif Rails.env.staging? || Rails.env.development?
               'https://staging.particulier.api.gouv.fr'
             else
               'https://particulier.api.gouv.fr'
             end
end

module DataPass
  BASE_URL = if Rails.env.sandbox?
               'https://sandbox.datapass.api.gouv.fr'
             elsif Rails.env.staging? || Rails.env.development?
               'https://staging.datapass.api.gouv.fr'
             else
               'https://datapass.api.gouv.fr'
             end
end
