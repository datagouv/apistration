class MESRI::Scolarite::ValidateCodeEtablissement < ValidateParamInteractor
  def call
    invalid_param!(:code_etablissement) if param(:code_etablissement).blank?

    return if param(:code_etablissement).match?(code_etablissement_regexp)

    invalid_param!(:code_etablissement)
  end

  private

  def code_etablissement_regexp
    /^\d{7}\w$/
  end
end
