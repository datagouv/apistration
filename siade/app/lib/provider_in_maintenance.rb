class ProviderInMaintenance < StandardError
  attr_reader :provider_name

  def initialize(provider_name)
    @provider_name = provider_name
  end
end
