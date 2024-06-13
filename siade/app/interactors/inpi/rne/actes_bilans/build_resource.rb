class INPI::RNE::ActesBilans::BuildResource < BuildResource
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
      types: format_types(acte['typeRdd'])
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
      type: bilan['typeBilan']
    }
  end
end
