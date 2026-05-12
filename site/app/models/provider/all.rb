class Provider::All
  attr_reader :api

  def initialize(api)
    @api = api.to_s
  end

  def uid = 'all'
  def name = 'Tous les fournisseurs'
  def scopes = provider_klass.all.flat_map(&:scopes).uniq
  def routes_or_uid_to_match = nil

  def all_provider? = true

  private

  def provider_klass
    Kernel.const_get("API#{api.classify}::Provider")
  end
end
