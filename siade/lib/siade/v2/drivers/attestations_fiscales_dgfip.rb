class SIADE::V2::Drivers::AttestationsFiscalesDGFIP < SIADE::V2::Drivers::GenericDriver
  include SIADE::V2::Drivers::SelfHostedDocumentDriver

  default_to_nil_raw_fetching_methods :document_url

  attr_accessor :siren, :siren_is, :siren_tva, :cookie, :informations

  def initialize(params)
    self.siren        = params[:siren]
    self.siren_is     = params.dig(:other_params, :siren_is)
    self.siren_tva    = params.dig(:other_params, :siren_tva)
    self.cookie       = params.dig(:other_params, :cookie)
    self.informations = params.dig(:other_params, :informations)
  end

  def provider_name
    'DGFIP'
  end

  def request
    @request ||= SIADE::V2::Requests::AttestationsFiscalesDGFIP.new({
      siren: siren,
      siren_is: siren_is,
      siren_tva: siren_tva,
      cookie: cookie,
      informations: informations
    })
  end

  private

  def document_file_type
    SIADE::SelfHostedDocument::File::PDF
  end

  def document_source
    @document_source ||= response.body
  end

  def document_name
    'attestation_fiscale_dgfip'
  end

  def document_storage_method
    :store_from_binary
  end
end
