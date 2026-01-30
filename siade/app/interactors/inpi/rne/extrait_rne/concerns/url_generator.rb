module INPI::RNE::ExtraitRNE::Concerns::UrlGenerator
  include INPI::RNE::ExtraitRNE::Concerns::Constants

  def link(target:, document_id:)
    url_for(
      controller: 'api_entreprise/inpi_proxy',
      action: 'show',
      uuid: encrypted_uuid(target:, document_id:),
      host:
    )
  end

  def encrypted_uuid(target:, document_id:)
    StringEncryptorService.instance.encrypt_url_safe(raw_uuid(target:, document_id:))
  end

  def raw_uuid(target:, document_id:)
    {
      target:,
      document_id:,
      timestamp:,
      token_id:
    }.to_json
  end

  def host
    Rails.env.production? ? PRODUCTION_HOST : "#{Rails.env}.#{PRODUCTION_HOST}"
  end

  def timestamp
    Time.zone.now.to_i
  end

  def token_id
    context.params[:token_id]
  end
end
