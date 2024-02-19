class CNAF::QuotientFamilial::ValidateResponse < ValidateResponse
  include CNAF::QuotientFamilial::ResponseBodyHelpers

  def call
    internal_server_error! if internal_server_error?
    unknown_provider_response! unless http_ok?

    resource_not_found! if not_found?

    unknown_provider_response! if qf_unavailable?

    return if http_ok? && data_present?

    unknown_provider_response!
  end

  private

  def resource_not_found!
    fail_with_error!(build_error(::NotFoundError, libelle_retour))
  end

  def data_present?
    data.css('adresse').present?
  end

  def not_found?
    beneficiary_not_found? ||
      disbared_beneficiary? ||
      data_missing?
  end

  def data_missing?
    !data_present?
  end

  def internal_server_error?
    http_code == 500 &&
      body.include?('Internal Server Error')
  end

  def beneficiary_not_found?
    libelle_retour.include?('Dossier allocataire inexistant')
  end

  def disbared_beneficiary?
    libelle_retour.include?('Dossier radié')
  end

  def libelle_retour
    xml_without_mime.css('libelleRetour').text
  end

  def qf_unavailable?
    data.css('quotients').css('QFMOIS').empty?
  end
end
