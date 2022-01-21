require 'open-uri'

class SIADE::V2::Drivers::CertificatsRGEADEME < SIADE::V2::Drivers::GenericDriver
  attr_reader :siret,
    :certification_entities

  def initialize(hash)
    @siret = hash[:siret]
    @skip_pdf = hash.dig(:user_params, :skip_pdf)
  end

  def provider_name
    'ADEME'
  end

  def request
    @request ||= SIADE::V2::Requests::CertificatsRGEADEME.new(@siret)
  end

  def check_response
    return if errors?

    @certification_entities = json_body.deep_transform_keys { |key| key.parameterize(separator: '_') }.try(:[], 'company')
  end

  def qualifications
    unique_qualifications.map do |qualification|
      format_qualification(qualification)
    end
  rescue SocketError, OpenSSL::SSL::SSLError, OpenURI::HTTPError, Net::OpenTimeout
    handle_calypso_error

    []
  end

  def domaines
    @domaines ||= unique_domaines.map do |domaine|
      format_domaine(domaine)
    end
  end

  private

  def unique_qualifications
    unique_entities('qualifications')
  end

  def unique_domaines
    unique_entities('domaines')
  end

  def unique_entities(kind)
    certification_entities.map do |entity|
      entity[kind].values
    end.flatten.uniq
  end

  def skip_pdf?
    @skip_pdf
  end

  def errors?
    request.errors.present?
  end

  def json_body
    response.json_body
  end

  def format_qualification(qualification)
    {
      nom: qualification['name'],
      nom_certificat: qualification['name_certif']
    }.merge(url_certificat_payload(qualification))
  end

  def format_domaine(domaine)
    domaine['nom']
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

    if pdf_from_calypso?(pdf_url)
      store_pdf.store_from_binary(
        download_file_with_dh_cipher_disabled(pdf_url)
      )
    else
      store_pdf.store_from_url(pdf_url)
    end

    if store_pdf.success?
      store_pdf.url
    else
      set_error_message_for(502)
      @errors.push(*build_store_pdf_errors(store_pdf))
    end
  end

  def build_store_pdf_errors(store_pdf)
    store_pdf.errors.map do |error|
      BadFileFromProviderError.new(provider_name, error[0], error[1])
    end
  end

  def pdf_from_calypso?(url)
    url.include?('www.qualypso.fr')
  end

  def download_file_with_dh_cipher_disabled(pdf_url)
    pdf_uri = URI(pdf_url)

    response = Net::HTTP.start(pdf_uri.host, 443, { use_ssl: true, ciphers: ['DEFAULT@SECLEVEL=1'] }) do |http|
      request = Net::HTTP::Get.new(pdf_uri)

      http.request(request)
    end

    response.body
  end

  def handle_calypso_error
    @http_code = 502
    (@errors ||= []) << ProviderInternalServerError.new(provider_name, 'Something\'s wrong with some files from Qualypso, retry later')
  end
end
