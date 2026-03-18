class SIADE::V3::Drivers::Geo::Localite < SIADE::V2::Drivers::GenericDriver
  default_to_nil_raw_fetching_methods :commune, :region

  def initialize(code_commune:)
    @code_commune = code_commune
  end

  def provider_name
    'API Geo'
  end

  def request
    @request ||= SIADE::V3::Requests::Geo::Localite.new(@code_commune)
  end

  def check_response; end

  protected

  def commune_raw
    @commune_raw ||= {
      code:  code_commune,
      value: libelle_commune
    }
  end

  def region_raw
    @region_raw ||= {
      code:  code_region,
      value: libelle_region
    }
  end

  def code_commune
    info_commune&.dig(:code)
  end

  def libelle_commune
    info_commune&.dig(:nom)
  end

  def code_region
    info_commune&.dig(:region, :code)
  end

  def libelle_region
    info_commune&.dig(:region, :nom)
  end

  def info_commune
    @info_commune ||= success? ? JSON.parse(response.body).deep_symbolize_keys : nil
  end
end
