class MatchIdentity::FamilyName < MatchIdentity::Base
  protected

  def match?
    context.candidate_identity[:nom_naissance] == context.reference_identity[:nom_naissance]
  end
end
