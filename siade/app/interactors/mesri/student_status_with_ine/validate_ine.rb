class MESRI::StudentStatusWithINE::ValidateINE < ValidateParamInteractor
  def call
    return if ine_number_valid?

    invalid_param!(:ine)
  end

  private

  def ine_number_valid?
    param(:ine).present? &&
      param(:ine) =~ /\A[0-9a-zA-Z]{11}\z/
  end
end
