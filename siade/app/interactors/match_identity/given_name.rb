class MatchIdentity::GivenName < MatchIdentity::Base
  protected

  def match?
    candidate_names = normalize_names(context.candidate_identity[:prenoms])
    reference_names = normalize_names(context.reference_identity[:prenoms])

    candidate_names.any? do |candidate_name|
      reference_names.any? do |reference_name|
        candidate_name == reference_name
      end
    end
  end

  private

  def normalize_names(names)
    Array(names).map { |name| name.to_s.downcase.strip }
  end
end
