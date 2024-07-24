module RecipientManagement
  protected

  def verify_recipient_is_a_siret!
    return if recipient_is_a_siret?

    raise_invalid_recipient!(InvalidRecipientError)
  end

  def verify_recipient_is_not_resource_id_nor_whitelist!
    return unless recipient_is_resource_siren_or_siret?
    return if recipient_whitelisted?

    raise_invalid_recipient!(RecipientAndResourceIdIdenticalError)
  end

  def raise_invalid_recipient!(error_klass)
    render json: ErrorsSerializer.new([error_klass.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  private

  def recipient_whitelisted?
    Rails.application.config_for('recipient_sirets_whitelist').any? do |recipient_siret_data|
      recipient_siret_data[:siret].first(9) == params[:recipient].strip.first(9)
    end
  end

  def recipient_is_resource_siren_or_siret?
    recipient_is_resource_siren? || recipient_is_resource_siret?
  end

  def recipient_is_resource_siren?
    return false unless params[:siren]

    params[:recipient].strip.first(9) == params[:siren].strip
  end

  def recipient_is_resource_siret?
    return false unless params[:siret]

    params[:recipient].strip == params[:siret].strip
  end

  def recipient_is_a_siret?
    ValidateSiret.call(params: { siret: params[:recipient] }).success?
  end
end
