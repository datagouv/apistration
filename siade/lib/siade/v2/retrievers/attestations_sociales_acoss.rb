class SIADE::V2::Retrievers::AttestationsSocialesACOSS < SIADE::V2::Retrievers::GenericInformationRetriever
  attr_reader :siren, :type_attestation
  register_driver :sociale, class_name: SIADE::V2::Drivers::AttestationsSocialesACOSS, init_with: :siren, init_options: :other_params
  fetch_attributes_through_driver :sociale, :http_code, :document_url

  def initialize(params)
    @siren = params.dig(:siren)
    @type_attestation = params.dig(:type_attestation)
    @user_id = params[:user_id]
    @recipient = params[:recipient]
  end

  def retrieve
    driver_sociale.perform_request
  end

  private

  def other_params
    {
      type_attestation: @type_attestation,
      user_id:          @user_id,
      recipient:        @recipient
    }
  end
end
