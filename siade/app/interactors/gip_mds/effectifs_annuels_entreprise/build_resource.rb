class GIPMDS::EffectifsAnnuelsEntreprise::BuildResource < GIPMDS::Effectifs::BuildResource
  protected

  def resource_attributes
    {
      siren:,
      annee:,
      effectifs_annuel: {
        regime_general:,
        regime_agricole:
      }
    }
  end

  private

  def siren
    json_body.first['siren']
  end
end
