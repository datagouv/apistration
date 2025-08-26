class MatchIdentity::MatchBirthdate < MatchIdentity::Base
  protected

  def match?
    annee_matches? && mois_matches? && jour_matches?
  end

  private

  def annee_matches?
    normalize_date_field(context.candidate_identity[:annee_date_naissance]) ==
      normalize_date_field(context.reference_identity[:annee_date_naissance])
  end

  def mois_matches?
    normalize_date_field(context.candidate_identity[:mois_date_naissance]) ==
      normalize_date_field(context.reference_identity[:mois_date_naissance])
  end

  def jour_matches?
    normalize_date_field(context.candidate_identity[:jour_date_naissance]) ==
      normalize_date_field(context.reference_identity[:jour_date_naissance])
  end

  def normalize_date_field(value)
    value.to_i
  end
end
