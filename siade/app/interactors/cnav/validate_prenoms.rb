class CNAV::ValidatePrenoms < ValidateParamInteractor
  def call
    invalid_param!(:first_names) unless valid_prenoms?
  end

  private

  def valid_prenoms?
    param(:prenoms).nil? ||
      (param(:prenoms).is_a?(Array) && !param(:prenoms).empty? && valid_string?)
  end

  def valid_string?
    param(:prenoms).all? { |p| /\A[a-zA-ZÀ-ÖØ-öø-ÿ' -]+\z/.match?(p) }
  end
end
