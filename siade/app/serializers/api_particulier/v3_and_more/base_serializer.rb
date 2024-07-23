class APIParticulier::V3AndMore::BaseSerializer < BaseSerializer
  class << self
    def url_domain
      'particulier.api.gouv.fr'
    end
  end
end
