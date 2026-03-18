class SIADE::V2::Drivers::CotisationsMSA < SIADE::V2::Drivers::GenericDriver
  attr_reader :siret

  default_to_nil_raw_fetching_methods :analyse_en_cours?, :a_jour?

  def initialize(hash)
    @siret = hash[:siret]
  end

  def provider_name
    'MSA'
  end

  def request
    @request ||= SIADE::V2::Requests::CotisationsMSA.new(@siret)
  end

  def check_response; end

  def analyse_en_cours_raw
    cotisation_status == "A"
  end

  def a_jour_raw
    cotisation_status == "O" unless analyse_en_cours?
  end

  def cotisation_status
    body = JSON::parse(response.body)
    body["TopRMPResponse"]["topRegMarchePublic"]
  end
end
