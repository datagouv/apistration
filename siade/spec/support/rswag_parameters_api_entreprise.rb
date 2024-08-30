module RSwagParametersAPIEntreprise
  def parameter_siren
    parameter name: :siren,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siren.description'),
      examples: SwaggerData.get('parameters.siren.examples')
  end

  def parameter_siret
    parameter name: :siret,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siret.description'),
      examples: SwaggerData.get('parameters.siret.examples')
  end

  def parameter_siret_or_rna
    parameter name: :siret_or_rna,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siret_or_rna.description'),
      examples: SwaggerData.get('parameters.siret_or_rna.examples')
  end

  def parameter_siren_or_rna
    parameter name: :siren_or_rna,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siren_or_rna.description'),
      examples: SwaggerData.get('parameters.siren_or_rna.examples')
  end

  def parameter_siret_or_eori
    parameter name: :siret_or_eori,
      in: :path,
      type: :string,
      description: SwaggerData.get('parameters.siret_or_eori.description'),
      examples: SwaggerData.get('parameters.siret_or_eori.examples')
  end
end
