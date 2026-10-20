class DatapassFormUids
  DEFINITIONS = %w[api_entreprise api_particulier].freeze

  def self.all
    new.all
  end

  def all
    DEFINITIONS.flat_map { |definition| client.list_formulaires(definition).pluck('uid') }.uniq
  end

  private

  def client
    @client ||= DatapassAPIClient.new
  end
end
