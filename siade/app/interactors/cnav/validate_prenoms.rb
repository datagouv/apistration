class CNAV::ValidatePrenoms < ValidateParamInteractor
  include ValidatePrenomsFormat

  def call
    return if param(:prenoms).nil?
    return invalid_param!(:first_names) unless valid_prenoms_format?

    invalid_param!(:first_names) unless valid_characters?
  end

  private

  def valid_characters?
    param(:prenoms).all? { |p| /\A[a-zA-ZÀ-ÖØ-öø-ÿ' -]+\z/.match?(p) }
  end
end
