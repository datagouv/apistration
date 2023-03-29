class GIPMDS::EffectifsMensuelsEtablissement::BuildResource < GIPMDS::Effectifs::BuildResource
  protected

  def resource_attributes
    {
      siret:,
      annee:,
      mois:,
      effectifs_mensuel: {
        regime_general:,
        regime_agricole:
      }
    }
  end

  private

  def siret
    json_body.first['siret']
  end

  def mois
    json_body
      .first['periode'][4..5]
  end
end
