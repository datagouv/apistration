class DatapassDefinition
  CACHE_DURATION = 6.hours

  def self.id(api)
    "api_#{api}"
  end

  def self.find(api)
    payload = Rails.cache.fetch("datapass_definitions/#{id(api)}", expires_in: CACHE_DURATION) do
      DatapassAPIClient.new.get_definition(id(api))
    end

    new(payload)
  end

  def initialize(payload)
    @payload = payload
  end

  def name
    @payload['name']
  end

  def scopes_by_group(values)
    scopes
      .select { |scope| values.include?(scope['value']) }
      .group_by { |scope| scope['group'] }
      .transform_values { |grouped_scopes| grouped_scopes.map { |scope| scope['name'] } }
  end

  private

  def scopes
    Array(@payload['scopes'])
  end
end
