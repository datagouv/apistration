class INSEE::Successions::BuildResource < BuildResource
  protected

  def resource_attributes
    {
      predecesseurs:,
      successeurs:
    }
  end

  private

  def predecesseurs
    format_raw_successions(predecesseurs_raw)
  end

  def successeurs
    format_raw_successions(successeurs_raw)
  end

  def format_raw_successions(raw_successions)
    raw_successions.map { |raw_succession| format_raw_succession(raw_succession) }
  end

  def format_raw_succession(raw_succession)
    {
      siret: succession_siret(raw_succession),
      date_succession: raw_succession['dateLienSuccession'],
      transfert_siege: raw_succession['transfertSiege'],
      continuite_economique: raw_succession['continuiteEconomique']
    }
  end

  def predecesseurs_raw
    successions_raw.select { |succession| siret_successeur(succession) == requested_siret }
  end

  def successeurs_raw
    successions_raw.select { |succession| siret_predecesseur(succession) == requested_siret }
  end

  def successions_raw
    json_body['liensSuccession']
  end

  def requested_siret
    context.params[:siret]
  end

  def succession_siret(raw_succession)
    if siret_predecesseur(raw_succession) == requested_siret
      siret_successeur(raw_succession)
    elsif siret_successeur(raw_succession) == requested_siret
      siret_predecesseur(raw_succession)
    else
      raise 'Requested siret is not in the succession'
    end
  end

  def siret_predecesseur(succession)
    succession['siretEtablissementPredecesseur']
  end

  def siret_successeur(succession)
    succession['siretEtablissementSuccesseur']
  end
end
