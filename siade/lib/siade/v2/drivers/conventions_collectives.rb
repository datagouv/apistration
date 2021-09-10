class SIADE::V2::Drivers::ConventionsCollectives < SIADE::V2::Drivers::GenericDriver
  attr_accessor :siret

  default_to_nil_raw_fetching_methods :conventions

  def initialize(siret:, **)
    @siret = siret
  end

  def provider_name
    'Fabrique numérique des Ministères Sociaux'
  end

  def request
    @request ||= SIADE::V2::Requests::ConventionsCollectives.new(siret)
  end

  def check_response; end

  def conventions_collectives_information
    @cc_information ||= JSON.parse(response.body).first.deep_transform_keys(&:underscore)
  end

  def conventions_raw
    conventions_collectives_information['conventions'].map do |conv|
      {
        active: conv['active'],
        date_publication: conv['date_publi'],
        etat: conv['etat'],
        numero: conv['num'],
        titre_court: conv['short_title'],
        titre: conv['title'],
        url: conv['url']
      }
    end
  end
end
