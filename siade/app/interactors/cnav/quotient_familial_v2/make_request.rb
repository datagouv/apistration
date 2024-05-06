class CNAV::QuotientFamilialV2::MakeRequest < CNAV::MakeRequest
  protected

  def mocking_params
    super.merge(
      annee: context.params[:annee],
      mois: context.params[:mois]
    ).compact
  end

  def request_params
    super.merge(
      anneeDemandee: context.params[:annee].presence || Time.zone.today.year,
      moisDemande: mois_demande
    ).compact
  end

  private

  def mois_demande
    Kernel.format('%<month>02d', month: context.params[:mois].presence&.to_i || Time.zone.today.month)
  end
end
