class SIADE::V2::Drivers::EORIDouanes < SIADE::V2::Drivers::GenericDriver
  attr_accessor :eori

  default_to_nil_raw_fetching_methods :numero_eori, :actif, :raison_sociale,
    :rue, :code_postal, :ville, :pays, :code_pays

  def initialize(eori:, **)
    @eori = eori
  end

  def provider_name
    'Douanes'
  end

  def request
    @request ||= SIADE::V2::Requests::EORIDouanes.new(eori: eori)
  end

  def check_response; end

  private

  def payload
    @payload ||= JSON
      .parse(response.body, symbolize_names: true)
      .dig(:EORI)
  end

  def numero_eori_raw
    payload.dig(:identifiant)
  end

  def actif_raw
    payload.dig(:actif)
  end

  def raison_sociale_raw
    payload.dig(:libelle)
  end

  def rue_raw
    payload.dig(:rue)
  end

  def code_postal_raw
    payload.dig(:codePostal)
  end

  def ville_raw
    payload.dig(:ville)
  end

  def pays_raw
    payload.dig(:pays)
  end

  def code_pays_raw
    payload.dig(:codePays)
  end
end
