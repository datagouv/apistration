class INSEE::AdresseEtablissementDiffusable::BuildUnfilteredResource < INSEE::AdresseEtablissement::BuildResource
  protected

  def diffusable_commercialement(status_diffusion)
    STATUT_DIFFUSION[status_diffusion] != :non_diffusible
  end
end
