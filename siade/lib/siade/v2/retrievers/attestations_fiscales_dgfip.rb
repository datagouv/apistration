class SIADE::V2::Retrievers::AttestationsFiscalesDGFIP < SIADE::V2::Retrievers::GenericInformationRetriever
  # Keep lowercase for IS and TVA to be compliant with the controller
  attr_accessor :siren, :siren_is, :siren_tva, :user_id, :cookie

  register_driver :dgfip, class_name: SIADE::V2::Drivers::AttestationsFiscalesDGFIP, init_with: :siren, init_options: :other_params

  fetch_attributes_through_driver :dgfip, :document_url

  def initialize(params)
    self.siren     = params.dig(:siren)
    self.siren_is  = params.dig(:siren_is)
    self.siren_tva = params.dig(:siren_tva)
    self.user_id   = params.dig(:user_id)
    self.cookie    = params.dig(:cookie)
  end

  def retrieve
    if success_insee_is? && success_insee_tva?
      # From here no error should be raised by Driver Etablissement because insee entreprise is OK
      driver_dgfip.perform_request
    end
  end

  def http_code
    http_code_is  = siren_is.nil?  ? 200 : entreprise_is.http_code
    http_code_tva = siren_tva.nil? ? 200 : entreprise_tva.http_code

    return http_code_is  if http_code_is  != 200
    return http_code_tva if http_code_tva != 200

    driver_dgfip.http_code
  end

  def errors
    errors = []
    errors += super
    errors += entreprise_is.errors  unless entreprise_is.nil?
    errors += entreprise_tva.errors unless entreprise_tva.nil?
    errors
  end

  protected

  def other_params
    { siren_is: siren_is, siren_tva: siren_tva, cookie: cookie, informations: retrieve_dgfip_informations }
  end

  private

  def retrieve_dgfip_informations
    SIADE::V2::Adapters::AttestationsFiscalesDGFIP.new(params_for_adapter)
  end

  def params_for_adapter
    {
      user_id: user_id,
      siren: siren,
      entreprise_is: entreprise_is,
      etablissement_is: etablissement_is,
      entreprise_tva: entreprise_tva,
      etablissement_tva: etablissement_tva
    }
  end

  def success_insee_is?
    siren_is.nil? || entreprise_is.http_code == 200
  end

  def success_insee_tva?
    siren_tva.nil? || entreprise_tva.http_code == 200
  end

  def entreprise_is
    return @entreprise_is unless @entreprise_is.nil?

    @entreprise_is = entreprise_insee siren_is unless siren_is.nil?

    @entreprise_is
  end

  def entreprise_tva
    return @entreprise_tva unless @entreprise_tva.nil?

    @entreprise_tva = entreprise_insee siren_tva unless siren_tva.nil?

    @entreprise_tva
  end

  def entreprise_insee(siren)
    SIADE::V2::Drivers::INSEE::Entreprise.new(siren: siren).perform_request
  end

  def etablissement_is
    return @etablissement_is unless @etablissement_is.nil?

    @etablissement_is = etablissement_insee entreprise_is.siret_siege_social unless siren_is.nil?

    @etablissement_is
  end

  def etablissement_tva
    return @etablissement_tva unless @etablissement_tva.nil?

    @etablissement_tva = etablissement_insee entreprise_tva.siret_siege_social unless siren_tva.nil?

    @etablissement_tva
  end

  def etablissement_insee(siret)
    SIADE::V2::Drivers::INSEE::Etablissement.new(siret: siret).perform_request
  end
end
