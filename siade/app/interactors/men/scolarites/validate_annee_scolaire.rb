class MEN::Scolarites::ValidateAnneeScolaire < ValidateParamInteractor
  def call
    return invalid_param!(:annee_scolaire) if param(:annee_scolaire).blank?

    return if param(:annee_scolaire).match?(anneee_scolaire_regexp)

    invalid_param!(:annee_scolaire)
  end

  private

  def anneee_scolaire_regexp
    /^(\d{4}|\d{4}-\d{4})$/
  end
end
