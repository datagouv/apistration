class Civility::ValidateNomNaissance < ValidateAttributePresence
  def call
    invalid_param!(:nom_naissance) unless param(:nom_naissance).present? && valid_characters?
  end

  private

  def valid_characters?
    param(:nom_naissance).match?(valid_chars)
  end

  def valid_chars
    /\A[a-zA-ZÀ-ÖØ-öø-ÿ' -]+\z/
  end
end
