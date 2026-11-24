class DatapassFormulaire
  class NotFound < StandardError; end

  CACHE_DURATION = 6.hours

  attr_reader :uid, :data

  def self.find(uid, api:)
    payload = all(api:).find { |formulaire| formulaire['uid'] == uid }

    raise NotFound, "DataPass formulaire #{uid} not found" if payload.nil?

    new(uid:, data: Hash.try_convert(payload['data']) || {})
  end

  def self.all(api:)
    definition_id = DatapassDefinition.id(api)

    Rails.cache.fetch("datapass_formulaires/#{definition_id}", expires_in: CACHE_DURATION) do
      DatapassAPIClient.new.list_formulaires(definition_id)
    end
  end

  def initialize(uid:, data:)
    @uid = uid
    @data = data
  end
end
