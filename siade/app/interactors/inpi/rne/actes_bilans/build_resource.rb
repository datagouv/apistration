class INPI::RNE::ActesBilans::BuildResource < BuildResource
  include Rails.application.routes.url_helpers

  protected

  def resource_attributes
    {
      actes:,
      bilans:
    }
  end

  private

  def actes
    raw_undeleted_actes.map { |acte| format_acte(acte) }
  end

  def raw_undeleted_actes
    json_body['actes'].reject { |acte| acte['deleted'] }
  end

  def format_acte(acte)
    {
      updated_at: normalized_date(acte['updatedAt']),
      date_depot: acte['dateDepot'],
      nom_document: acte['nomDocument'],
      id: acte['id'],
      types: format_types(acte['typeRdd']),
      link: link(target: 'actes', id: acte['id'])
    }
  end

  def format_types(types)
    types&.map { |type| format_type(type) }
  end

  def format_type(type)
    {
      acte: type['typeActe'],
      decision: type['decision']
    }.compact
  end

  def bilans
    raw_undeleted_bilans.map { |bilan| format_bilan(bilan) }
  end

  def raw_undeleted_bilans
    json_body['bilans'].reject { |bilan| bilan['deleted'] }
  end

  def format_bilan(bilan)
    {
      updated_at: normalized_date(bilan['updatedAt']),
      date_depot: bilan['dateDepot'],
      nom_document: bilan['nomDocument'],
      id: bilan['id'],
      date_cloture: bilan['dateCloture'],
      type: bilan['typeBilan'],
      link: link(target: 'bilans', id: bilan['id'])
    }
  end

  def link(target:, id:)
    url_for(
      controller: 'api_entreprise/inpi_proxy',
      action: 'show',
      uuid: encrypted_uuid(target:, id:),
      host:
    )
  end

  def encrypted_uuid(target:, id:)
    StringEncryptorService.instance.encrypt_url_safe(raw_uuid(target:, id:))
  end

  def raw_uuid(target:, id:)
    "#{target}-#{id}-#{timestamp}-#{token_id}"
  end

  def host
    Rails.env.production? ? 'entreprise.api.gouv.fr' : "#{Rails.env}.entreprise.api.gouv.fr"
  end

  def timestamp
    Time.zone.now.to_i
  end

  def token_id
    context.params[:token_id]
  end
end
