class CNAF::ValidatePrenoms < ValidateParamInteractor
  def call
    invalid_param!(:first_names) unless valid_prenoms?
  end

  private

  def valid_prenoms?
    param(:prenoms).nil? ||
      (param(:prenoms).is_a?(Array) && !param(:prenoms).empty?)
  end
end
