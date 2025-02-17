class DSNJ::ServiceNational::ValidatePrenoms < ValidateParamInteractor
  def call
    invalid_param!(:prenoms) if param(:prenoms).blank? || !param(:prenoms).is_a?(Array) || !valid_characters?
  end

  private

  def valid_characters?
    param(:prenoms).all? { |prenom| prenom.match?(valid_chars) }
  end

  def valid_chars
    /^[A-Za-zÀÂÄÇÉÈÊËÎÏÔÖÙÛÜŸàâäçéèêëîïôöùûüÿÆæ \-]+$/
  end
end
