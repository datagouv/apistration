class INSEE::UniteLegaleDiffusable::BuildUnfilteredResource < INSEE::UniteLegale::BuildResource
  protected

  def diffusable_commercialement(status_diffusion)
    STATUT_DIFFUSION[status_diffusion] != :non_diffusible
  end
end
