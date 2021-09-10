class SIADE::V2::Drivers::AttestationsSocialesACOSS < SIADE::V2::Drivers::GenericDriver
  include SIADE::V2::Drivers::SelfHostedDocumentDriver

  default_to_nil_raw_fetching_methods :document_url

  attr_accessor :siren, :type_attestation, :user_id, :recipient

  def initialize(params)
    @siren = params[:siren]
    @type_attestation = params.dig(:other_params, :type_attestation)
    @user_id = params.dig(:other_params, :user_id)
    @recipient = params.dig(:other_params, :recipient)
  end

  def provider_name
    'ACOSS'
  end

  def request
    @request ||= SIADE::V2::Requests::AttestationsSocialesACOSS.new(
      {
        siren: siren,
        type_attestation: type_attestation,
        user_id: user_id,
        recipient: recipient
      }
    )
  end

  private

  def document_file_type
    SIADE::SelfHostedDocument::File::PDF
  end

  def document_name
    'attestation_vigilance_acoss'
  end

  def document_source
    response.body
  end

  def document_storage_method
    :store_from_base64
  end
end
