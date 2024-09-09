# rubocop:disable Metrics/ModuleLength
module RSwagParametersAPIParticulier
  def parameters_cnav_identite_pivot_nom_usage(required)
    parameter name: :nomUsage,
      in: :query,
      type: SwaggerData.get('parameters.civility.nomUsage.type'),
      description: SwaggerData.get('parameters.civility.nomUsage.description'),
      example: SwaggerData.get('parameters.civility.nomUsage.example'),
      required:
  end

  def parameters_cnav_identite_pivot_nom_naissance(required)
    parameter name: :nomNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.nomNaissance.type'),
      description: SwaggerData.get('parameters.civility.nomNaissance.description'),
      example: SwaggerData.get('parameters.civility.nomNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_prenoms(required)
    parameter name: :'prenoms[]',
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.prenoms.type'),
        minItems: SwaggerData.get('parameters.civility.prenoms.minItems'),
        items: { type: :string },
        example: SwaggerData.get('parameters.civility.prenoms.example')
      },
      description: SwaggerData.get('parameters.civility.prenoms.description'),
      required:
  end

  def parameters_cnav_identite_pivot_annee_date_de_naissance(required)
    parameter name: :anneeDateDeNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.anneeDateDeNaissance.type'),
      description: SwaggerData.get('parameters.civility.anneeDateDeNaissance.description'),
      example: SwaggerData.get('parameters.civility.anneeDateDeNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_mois_date_de_naissance(required)
    parameter name: :moisDateDeNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.moisDateDeNaissance.type'),
      description: SwaggerData.get('parameters.civility.moisDateDeNaissance.description'),
      example: SwaggerData.get('parameters.civility.moisDateDeNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_jour_date_de_naissance(required)
    parameter name: :jourDateDeNaissance,
      in: :query,
      type: SwaggerData.get('parameters.civility.jourDateDeNaissance.type'),
      description: SwaggerData.get('parameters.civility.jourDateDeNaissance.description'),
      example: SwaggerData.get('parameters.civility.jourDateDeNaissance.example'),
      required:
  end

  def parameters_cnav_identite_pivot_code_cog_insee_commune_de_naissance(required)
    parameter name: :codeCogInseeCommuneDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.minLength'),
        maxLength: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.maxLength'),
        example: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.codeCogInseeCommuneDeNaissance.description'),
      required:
  end

  def parameters_cnav_identite_pivot_code_pays_lieu_de_naissance(required)
    parameter name: :codePaysLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.maxLength'),
        example: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.codePaysLieuDeNaissance.description'),
      required:
  end

  def parameters_cnav_identite_pivot_sexe_etat_civil(required)
    parameter name: :sexeEtatCivil,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.sexeEtatCivil.type'),
        enum: SwaggerData.get('parameters.civility.sexeEtatCivil.enum')
      },
      description: SwaggerData.get('parameters.civility.sexeEtatCivil.description'),
      example: SwaggerData.get('parameters.civility.sexeEtatCivil.example'),
      required:
  end

  def parameters_cnav_identite_pivot_nom_commune_naissance(required)
    parameter name: :nomCommuneNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.nomCommuneNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.nomCommuneNaissance.minLength'),
        example: SwaggerData.get('parameters.civility.nomCommuneNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.nomCommuneNaissance.description'),
      required:
  end

  def parameters_cnav_identite_pivot_code_cog_insee_departement_de_naissance(required)
    parameter name: :codeCogInseeDepartementNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.type'),
        minLength: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.minLength'),
        maxLength: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.maxLength'),
        example: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.example')
      },
      description: SwaggerData.get('parameters.civility.codeCogInseeDepartementDeNaissance.description'),
      required:
  end

  # rubocop:disable Metrics/AbcSize
  def parameters_cnav_identite_pivot(params: [], required: [])
    params.each do |param|
      public_send("parameters_cnav_identite_pivot_#{param.underscore}", required.include?(param))
    end
  end

  # rubocop:disable Metrics/MethodLength
  def parameters_cnav_identite_pivot_v2
    parameter name: :nomUsage,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomUsage.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomUsage.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomUsage.example'),
      required: false

    parameter name: :nomNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomNaissance.example'),
      required: false

    parameter name: :'prenoms[]',
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.type'),
        minItems: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.minItems'),
        items: { type: :string },
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.prenoms.description'),
      required: false

    parameter name: :anneeDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.anneeDateDeNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.anneeDateDeNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.anneeDateDeNaissance.example'),
      required: false

    parameter name: :moisDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.moisDateDeNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.moisDateDeNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.moisDateDeNaissance.example'),
      required: false

    parameter name: :jourDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.commons.cnav_identite_pivot.jourDateDeNaissance.type'),
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.jourDateDeNaissance.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.jourDateDeNaissance.example'),
      required: false

    parameter name: :codeInseeLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.maxLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.description'),
      required: false

    parameter name: :codePaysLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.maxLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.codePaysLieuDeNaissance.description'),
      required: false

    parameter name: :sexe,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.type'),
        enum: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.enum')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.description'),
      example: SwaggerData.get('cnav.commons.cnav_identite_pivot.sexe.example'),
      required: false

    parameter name: :nomCommuneNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.minLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.nomCommuneNaissance.description'),
      required: false

    parameter name: :codeInseeDepartementNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.type'),
        minLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.maxLength'),
        example: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.example')
      },
      description: SwaggerData.get('cnav.commons.cnav_identite_pivot.codeInseeDepartementNaissance.description'),
      required: false
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength
