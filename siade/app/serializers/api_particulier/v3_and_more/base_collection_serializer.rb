class APIParticulier::V3AndMore::BaseCollectionSerializer < BaseCollectionSerializer
  class << self
    def url_domain
      'particulier.api.gouv.fr'
    end
  end
end
