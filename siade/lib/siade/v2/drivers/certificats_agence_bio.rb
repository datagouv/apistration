class SIADE::V2::Drivers::CertificatsAgenceBIO < SIADE::V2::Drivers::GenericDriver
  attr_reader :siret

  def initialize(siret:, **)
    @siret = siret
  end

  def provider_name
    'Agence BIO'
  end

  def request
    @request ||= SIADE::V2::Requests::CertificatsAgenceBIO.new(siret)
  end

  def check_response; end

  def raw_organic_certifications
    @raw_organic_certifications ||= body[:items]
  end

  def body
    @body ||= JSON.parse(response.body).deep_transform_keys { |key| key.to_s.underscore }.deep_symbolize_keys
  end

  def filtered_certifications_data
    raw_organic_certifications.map do |cert_data|
      {
        siret: value_or_placeholder(:siret, cert_data),
        numero_bio: value_or_placeholder(:numero_bio, cert_data),
        date_derniere_mise_a_jour: value_or_placeholder(:date_maj, cert_data),
        reseau: value_or_placeholder(:reseau, cert_data),
        categories: format_categories(cert_data),
        activites: format_activites(cert_data),
        adresses_operateurs: format_addresses(cert_data),
        productions: format_productions(cert_data),
        certificats: format_certificats(cert_data)
      }
    end
  end

  def format_certificats(raw_data)
    raw_certifs = raw_data.try(:[], :certificats)
    return [] unless raw_certifs

    raw_certifs.each_with_object([]) do |cert, res|
      formatted_certif = {
        organisme: value_or_placeholder(:organisme, cert),
        date_engagement: value_or_placeholder(:date_engagement, cert),
        date_arret: value_or_placeholder(:date_arret, cert),
        date_suspension: value_or_placeholder(:date_suspension, cert),
        url: value_or_placeholder(:url, cert),
        etat_certification: value_or_placeholder(:etat_certification, cert)
      }
      res << formatted_certif
    end
  end

  def format_productions(raw_data)
    raw_products = raw_data.try(:[], :productions)
    return [] unless raw_products

    raw_products.each_with_object([]) do |product, res|
      formatted_product = {
        nom: value_or_placeholder(:nom, product),
        code: value_or_placeholder(:code, product)
      }
      res << formatted_product
    end
  end

  def format_activites(raw_data)
    raw_activites = raw_data.try(:[], :activites)
    return [] unless raw_activites

    raw_activites.each_with_object([]) { |act, res| res << act.try(:[], :nom) }
  end

  def format_addresses(raw_data)
    raw_addr_operateurs = raw_data.try(:[], :adresses_operateurs)
    return [] unless raw_addr_operateurs

    raw_addr_operateurs.each_with_object([]) do |addr, res|
      formatted_addr = {
        lieu: value_or_placeholder(:lieu, addr),
        code_postal: value_or_placeholder(:code_postal, addr),
        ville: value_or_placeholder(:ville, addr),
        lat: value_or_placeholder(:lat, addr),
        long: value_or_placeholder(:long, addr),
        type: value_or_placeholder(:type_adresse_operateurs, addr)
      }
      res << formatted_addr
    end
  end

  def format_categories(raw_data)
    raw_categories = raw_data.try(:[], :categories)
    return [] unless raw_categories

    raw_categories.each_with_object([]) { |cat, res| res << cat.try(:[], :nom) }
  end
end
