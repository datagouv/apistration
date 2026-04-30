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
    (json_body['actes'] || []).reject { |acte| acte['deleted'] }
  end

  def format_acte(acte)
    {
      id: acte['id'],
      nom_document: acte['nomDocument'],
      date_depot: acte['dateDepot'],
      date_mise_a_jour: normalized_date(acte['updatedAt']),
      types_actes: format_types_actes(acte['typeRdd']),
      url: link(target: 'actes', document_id: acte['id'])
    }
  end

  def format_types_actes(types)
    types&.map { |type| format_type_acte(type) }
  end

  def format_type_acte(type)
    {
      type_acte: type['typeActe'],
      type_decision: type['decision']
    }.compact
  end

  def bilans
    raw_undeleted_bilans.map { |bilan| format_bilan(bilan) }
  end

  def raw_undeleted_bilans
    (json_body['bilans'] || []).reject { |bilan| bilan['deleted'] }
  end

  def format_bilan(bilan)
    {
      id: bilan['id'],
      nom_document: bilan['nomDocument'],
      date_depot: bilan['dateDepot'],
      date_cloture: bilan['dateCloture'],
      date_mise_a_jour: normalized_date(bilan['updatedAt']),
      type: code_to_label_bilan[bilan['typeBilan']],
      url: link(target: 'bilans', document_id: bilan['id'])
    }
  end

  def link(target:, document_id:)
    url_for(
      controller: 'api_entreprise/inpi_proxy',
      action: 'show',
      uuid: encrypted_uuid(target:, document_id:),
      host:
    )
  end

  def code_to_label_bilan
    {
      'C' => 'bilan complet',
      'S' => 'bilan simplifié',
      'K' => 'bilan consolidé',
      'B' => 'bilan de type banque',
      'A' => 'bilan de type assurance',
      'AS' => 'bilan de type agricole simplifié'
    }
  end

  def encrypted_uuid(target:, document_id:)
    StringEncryptorService.instance.encrypt_url_safe(raw_uuid(target:, document_id:))
  end

  def raw_uuid(target:, document_id:)
    {
      target:,
      document_id:,
      timestamp:,
      token_id:,
      token_type:,
      authorization_request_id:
    }.to_json
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

  def token_type
    context.params[:token_type]
  end

  def authorization_request_id
    context.params[:authorization_request_id]
  end
end
