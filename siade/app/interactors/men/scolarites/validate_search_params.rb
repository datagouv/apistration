class MEN::Scolarites::ValidateSearchParams < ValidateParamInteractor
  def call
    if code_etablissement_provided? && perimetre_provided?
      invalid_param!(:code_etablissement_et_perimetre)
    elsif code_etablissement_provided?
      MEN::Scolarites::ValidateCodeEtablissement.call!(context)
    elsif perimetre_provided?
      MEN::Scolarites::ValidateDegreEtablissement.call!(context)
      MEN::Scolarites::ValidatePerimetre.call!(context)
    else
      invalid_param!(:code_etablissement)
    end
  end

  private

  def code_etablissement_provided?
    param(:code_etablissement).present?
  end

  def perimetre_provided?
    MEN::Scolarites::ValidatePerimetre::PERIMETRE_MAPPING.keys.any? do |key|
      param(key).present?
    end
  end
end
