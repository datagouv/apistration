class DGFIP::TVA::BuildTVANumberFromSiren < ApplicationInteractor
  def call
    context.tva_number = tva_intracommunautaire.perform
    context.tva_number_candidates = tva_intracommunautaire.candidates
  end

  private

  def tva_intracommunautaire
    @tva_intracommunautaire ||= TVAIntracommunautaire.new(context.params[:siren])
  end
end
