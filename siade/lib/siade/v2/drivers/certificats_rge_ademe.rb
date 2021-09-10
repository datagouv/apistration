require 'open-uri'

class SIADE::V2::Drivers::CertificatsRGEAdeme < SIADE::V2::Drivers::GenericDriver
  attr_reader :siret

  default_to_nil_raw_fetching_methods :domaines,
    :qualifications

  def initialize(hash)
    @siret = hash[:siret]
    @skip_pdf = hash.dig(:user_params, :skip_pdf)
  end

  def provider_name
    'Ademe'
  end

  def request
    @request ||= SIADE::V2::Requests::CertificatsRGEAdeme.new(@siret)
  end

  def check_response
    remove_bom_from_json_response unless errors?
  end

  private

  def skip_pdf?
    @skip_pdf
  end

  def remove_bom_from_json_response
    @certification_entities ||=
      JSON.parse(body_without_bom).deep_transform_keys { |key| key.parameterize(separator: '_') }
  rescue StandardError
    set_parsing_response_error
  end

  def errors?
    request.errors.present?
  end

  def certification_entities
    # Ensure with ADEME API specifications that when requested with a siret
    # only one result (the one for the corresponding etablissement) is returned
    @certification_entities.try(:[], 'company')
  end

  def body_without_bom
    response.body.force_encoding('UTF-8').sub(/^\xEF\xBB\xBF/, '')
  end

  def qualifications_raw
    certification_entities.each do |entity|
      entity_raw_qualifications = entity.try(:[], 'qualifications')
      format_raw_qualifications(entity_raw_qualifications)
    end
    aggregated_qualifications
  end

  def format_raw_qualifications(raw_qualifs)
    raw_qualifs.reduce(aggregated_qualifications) do |result, (_, qualif_obj)|
      result.push(
        {
          nom: qualif_obj['name'],
          nom_certificat: qualif_obj['name_certif']
        }.merge(url_certificat_payload(qualif_obj))
      )
    end
  end

  def aggregated_qualifications
    @aggregated_qualifications ||= []
  end

  def domaines_raw
    certification_entities.each do |entity|
      entity_raw_domaines = entity.try(:[], 'domaines')
      format_raw_domaines(entity_raw_domaines)
    end
    aggregated_domaines
  end

  def format_raw_domaines(raw_domaines)
    raw_domaines.reduce(aggregated_domaines) do |result, (_, domaine_obj)|
      result.push(domaine_obj['nom'])
    end
  end

  def aggregated_domaines
    @aggregated_domaines ||= []
  end

  def url_certificat_payload(qualif_obj)
    if skip_pdf?
      { url_certificat: nil }
    else
      { url_certificat: self_hosted_pdf(qualif_obj['url']) }
    end
  end

  def self_hosted_pdf(pdf_url)
    store_pdf = SIADE::SelfHostedDocument::File::PDF.new('certificat_rge_ademe')
    store_pdf.store_from_url(pdf_url)

    if store_pdf.success?
      store_pdf.url
    else
      set_error_message_for(502)
      @errors.push(*build_store_pdf_errors(store_pdf))
    end
  end

  def build_store_pdf_errors(store_pdf)
    store_pdf.errors.map do |raw_error|
      BadFileFromProviderError.new(provider_name, raw_error[0], raw_error[1])
    end
  end
end
