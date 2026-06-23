class AbstractCasUsage
  include ActiveModel::Model
  include AbstractAPIClass

  ATTRIBUTES = %i[
    name
    url
    description
    icon
    administrations
    public_cible
  ].freeze

  attr_accessor(*ATTRIBUTES)

  def self.all(api: self.api)
    SimplifionsStore.instance.all(api:)
  end

  def self.for_endpoint(endpoint_uid, api: self.api)
    SimplifionsStore.instance.for_endpoint(endpoint_uid, api:)
  end
end
