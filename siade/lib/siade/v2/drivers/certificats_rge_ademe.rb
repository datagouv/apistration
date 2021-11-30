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

    @certification_entities = JSON.parse(body_without_bom).deep_transform_keys { |key| key.parameterize(separator: '_') }.try(:[], 'company')
  end

  def qualifications
    certification_entities.each do |entity|
      entity_qualifications = entity.try(:[], 'qualifications')

      break if entity_qualifications.empty?

      format_qualifications(entity_qualifications)
    end

    aggregated_qualifications
  rescue SocketError, OpenSSL::SSL::SSLError, OpenURI::HTTPError, Net::OpenTimeout
    handle_calypso_error

    []
  end

  def domaines
    certification_entities.each do |entity|
      entity_domaines = entity.try(:[], 'domaines')
      format_domaines(entity_domaines)
    end

    aggregated_domaines
  end

  private

  def skip_pdf?
    @skip_pdf
  end

  def errors?
    request.errors.present?
  end

  def body_without_bom
    response.body_without_bom
  end

  def format_qualifications(qualifs)
    qualifs.reduce(aggregated_qualifications) do |result, (_, qualif_obj)|
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

  def format_domaines(domaines)
    if domaines.first.is_a?(String)
      aggregated_domaines.concat(domaines)
    else
      domaines.reduce(aggregated_domaines) do |result, (_, domaine_obj)|
        result.push(domaine_obj['nom'])
      end
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
