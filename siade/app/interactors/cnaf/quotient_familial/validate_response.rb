class CNAF::QuotientFamilial::ValidateResponse < ValidateResponse
  def call
    unknown_provider_response! unless http_ok?

    resource_not_found! if not_found?

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

  def data
    Nokogiri.XML(xml_without_mime.css('fluxRetour').children.text)
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

  def xml_without_mime
    @xml_without_mime ||= Nokogiri.XML(response.body.split("\n")[4..].join("\n").strip)
  end
end
