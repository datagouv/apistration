class SIADE::V2::Drivers::CertificatsOPQIBI < SIADE::V2::Drivers::GenericDriver
  attr_accessor :siren

  default_to_nil_raw_fetching_methods :numero_certificat, :date_de_delivrance_du_certificat, :duree_de_validite_du_certificat, :assurance, :url,
    :qualifications,
    :date_de_validite_des_qualifications,
    :qualifications_probatoires,
    :date_de_validite_des_qualifications_probatoires

  def initialize(hash)
    @siren = hash[:siren]
  end

  def provider_name
    'OPQIBI'
  end

  def request
    @request ||= SIADE::V2::Requests::CertificatsOPQIBI.new(@siren)
  end

  def check_response; end

  protected

  def certificat_informations
    @certificat_informations ||= JSON.parse(response.body, symbolize_names: true)
  rescue JSON::ParserError => e
    Rails.logger.error e.message
    ''
  end

  def numero_certificat_raw
    certificat_informations[:numero_certificat]
  end

  def date_de_delivrance_du_certificat_raw
    certificat_informations[:date_de_delivrance_du_certificat]
  end

  def duree_de_validite_du_certificat_raw
    certificat_informations[:duree_de_validite_du_certificat]
  end

  def assurance_raw
    certificat_informations[:assurance]
  end

  def url_raw
    certificat_informations[:url]
  end

  def qualifications_raw
    qualifications_snake_case(certificat_informations[:qualifications])
  end

  def date_de_validite_des_qualifications_raw
    certificat_informations[:date_de_validite_des_qualification]
  end

  def qualifications_probatoires_raw
    qualifications_probatoires_snake_case(certificat_informations[:qualifications_probatoires])
  end

  def date_de_validite_des_qualifications_probatoires_raw
    certificat_informations[:date_de_validite_des_qualifications_probatoires]
  end

  def qualifications_snake_case(qualifications)
    qualifications.map do |qualification|
      {
        code_qualification: qualification[:CodeQualification],
        nom: qualification[:Nom],
        definition: qualification[:Definition],
        rge: qualification[:rge]
      }
    end
  end

  def qualifications_probatoires_snake_case(qualifications_probatoires)
    qualifications_snake_case(qualifications_probatoires)
  end
end
