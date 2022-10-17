class EuropeanCommission::VIES::BuildTVANumberFromSiren < ApplicationInteractor
  def call
    context.tva_number = TVAIntracommunautaire.new(siren).perform
  end

  private

  def siren
    context.params[:siren]
  end
end
