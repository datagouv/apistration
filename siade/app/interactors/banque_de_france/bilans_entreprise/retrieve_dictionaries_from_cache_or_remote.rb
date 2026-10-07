class BanqueDeFrance::BilansEntreprise::RetrieveDictionariesFromCacheOrRemote < DGFIP::LiassesFiscales::RetrieveDictionariesWithFallback
  delegates_to DGFIP::LiassesFiscales::RetrieveDictionaryFromCacheOrRemote

  protected

  def years_with_fallback_by_key
    bilans.to_h { |bilan| [bilan.date_arrete_exercice, [millesime_year(bilan), bilan.annee]] }
  end

  private

  def millesime_year(bilan)
    return bilan.annee unless bilan.date_arrete_exercice.end_with?('-12')

    (bilan.annee.to_i + 1).to_s
  end

  def bilans
    context.bundled_data.data
  end
end
