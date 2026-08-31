class CNAV::QuotientFamilialV2::MakeRequest < CNAV::MakeRequest
  protected

  def mocking_params_v2
    super.merge(
      annee: context.params[:annee],
      mois: context.params[:mois]
    ).compact
  end

  def mocking_params
    super.merge(
      annee: context.params[:annee],
      mois: context.params[:mois]
    ).compact
  end

  def request_params
    super.merge(
      anneeDemandee: context.params[:annee].presence,
      moisDemande: mois_demande
    ).compact
  end

  private

  def mois_demande
    mois = context.params[:mois].presence
    return nil if mois.nil?

    Kernel.format('%<month>02d', month: mois.to_i)
  end
end
