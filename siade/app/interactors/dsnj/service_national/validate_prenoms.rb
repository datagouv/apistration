class DSNJ::ServiceNational::ValidatePrenoms < ValidateParamInteractor
  include ValidatePrenomsFormat

  def call
    return invalid_param!(:prenoms) unless valid_prenoms_format?

    invalid_param!(:prenoms) unless valid_characters?
  end

  private

  def valid_characters?
    param(:prenoms).all? { |p| p.match?(/\A[a-zA-ZÀ-ÖØ-öø-ÿÆæ' -]+\z/) }
  end
end
