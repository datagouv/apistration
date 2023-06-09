class GIPMDS::EffectifsAnnuelsEntreprise::BuildResource < GIPMDS::Effectifs::BuildResource
  protected

  def resource_attributes
    {
      siren:,
      effectifs_annuel: cleaned_effectifs
    }
  end

  private

  def siren
    context.params[:siren]
  end
end
