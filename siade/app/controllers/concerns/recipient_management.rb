module RecipientManagement
  protected

  def verify_recipient_is_a_siret!
    return if recipient_is_a_siret?

    raise_invalid_recipient!(InvalidRecipientError)
  end

  def raise_invalid_recipient!(error_klass)
    render json: ErrorsSerializer.new([error_klass.new], format: error_format).as_json,
      status: :unprocessable_content
  end

  private

  def recipient_is_a_siret?
    ValidateSiret.call(params: { siret: params[:recipient] }).success?
  end
end
