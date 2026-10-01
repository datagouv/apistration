class DatapassFormulaire
  class NotFound < StandardError; end

  DEFINITION_ID = 'api_entreprise'.freeze
  CACHE_DURATION = 6.hours

  attr_reader :uid, :data

  def self.find(uid)
    payload = all.find { |formulaire| formulaire['uid'] == uid }

    raise NotFound, "DataPass formulaire #{uid} not found" if payload.nil?

    new(uid:, data: Hash.try_convert(payload['data']) || {})
  end

  def self.all
    Rails.cache.fetch("datapass_formulaires/#{DEFINITION_ID}", expires_in: CACHE_DURATION) do
      DatapassAPIClient.new.list_formulaires(DEFINITION_ID)
    end
  end

  def initialize(uid:, data:)
    @uid = uid
    @data = data
  end
end
