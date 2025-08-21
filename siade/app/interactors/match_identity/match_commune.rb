class MatchIdentity::MatchCommune < MatchIdentity::Base
  protected

  def match?
    return false unless context.reference_identity[:code_cog_insee_commune_naissance]
    return false unless context.candidate_identity[:code_departement_naissance]

    context.reference_identity[:code_cog_insee_commune_naissance].start_with?(
      context.candidate_identity[:code_departement_naissance]
    )
  end
end
