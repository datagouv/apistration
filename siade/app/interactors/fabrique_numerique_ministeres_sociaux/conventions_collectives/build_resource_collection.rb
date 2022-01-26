class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::BuildResourceCollection < BuildResourceCollection
  protected

  def items
    conventions
  end

  def items_meta
    {
      count: conventions.count
    }
  end

  def resource_attributes(convention)
    {
      id: convention['id'],
      numero_idcc: convention['num'],
      titre: convention['title'].strip,
      titre_court: convention['shortTitle'].strip,
      active: convention['active'],
      etat: humanized_etat(convention['etat']),
      url: convention['url'],
      synonymes: convention['synonymes'] || [],
      date_publication: Date.parse(convention['date_publi']).to_s
    }
  end

  private

  def conventions
    json_body[0]['conventions']
  end

  def humanized_etat(etat)
    case etat
    when 'VIGUEUR'
      'vigueur'
    when 'VIGUEUR_ETEN'
      'vigueur_etendue'
    else
      etat
    end
  end
end
