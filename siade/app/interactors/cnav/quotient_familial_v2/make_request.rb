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
    Kernel.format('%<month>02d', month: context.params[:mois].to_i) if context.params[:mois].present?
  end
end
