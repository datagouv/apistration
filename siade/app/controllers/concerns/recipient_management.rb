module RecipientManagement
  protected

  def verify_recipient_is_a_siret_or_nil!
    return if params[:recipient].blank?

    verify_recipient_is_a_siret!
  end

  def verify_recipient_is_a_siret!
    return if recipient_is_a_siret?

    if api_kind == 'api_entreprise'
      raise_invalid_recipient_api_entreprise!(InvalidRecipientError)
    else
      raise_invalid_recipient_api_particulier!
    end
  end

  def verify_recipient_is_not_resource_id_nor_whitelist!
    return unless recipient_is_resource_siren_or_siret?
    return if recipient_whitelisted?

    raise_invalid_recipient_api_entreprise!(RecipientAndResourceIdIdenticalError)
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

  def raise_invalid_recipient_api_entreprise!(error_klass)
    render json: ErrorsSerializer.new([error_klass.new], format: error_format).as_json,
      status: :unprocessable_entity
  end

  def raise_invalid_recipient_api_particulier!
    render json: format_error(InvalidRecipientError.new),
      status: :bad_request
  end
end
