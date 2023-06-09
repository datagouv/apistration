class GIPMDS::EffectifsMensuelsEtablissement::BuildResource < GIPMDS::Effectifs::BuildResource
  protected

  def resource_attributes
    {
      siret:,
      depth:,
      effectifs_mensuels: cleaned_effectifs
    }
  end

  private

  def siret
    context.params[:siret]
  end

  def depth
    context.params[:depth] || '0'
  end
end
