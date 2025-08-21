class MatchIdentity::MatchSexe < MatchIdentity::Base
  protected

  def match?
    context.candidate_identity[:sexe_etat_civil] == context.reference_identity[:sexe_etat_civil]
  end
end
