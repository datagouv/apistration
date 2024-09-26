# rubocop:disable Metrics/ModuleLength
module RSwagParametersAPIParticulier
  def parameters_identite_pivot_nom_usage(required, api)
    parameter name: :nomUsage,
      in: :query,
      type: SwaggerData.get("civility.#{api}.nomUsage.type"),
      description: SwaggerData.get("civility.#{api}.nomUsage.description"),
      example: SwaggerData.get("civility.#{api}.nomUsage.example"),
      required:
  end

  def parameters_identite_pivot_nom_naissance(required, api)
    parameter name: :nomNaissance,
      in: :query,
      type: SwaggerData.get("civility.#{api}.nomNaissance.type"),
      description: SwaggerData.get("civility.#{api}.nomNaissance.description"),
      example: SwaggerData.get("civility.#{api}.nomNaissance.example"),
      required:
  end

  def parameters_identite_pivot_prenoms(required, api)
    parameter name: :'prenoms[]',
      in: :query,
      schema: {
        type: SwaggerData.get("civility.#{api}.prenoms.type"),
        minItems: SwaggerData.get("civility.#{api}.prenoms.minItems"),
        maxItems: SwaggerData.get("civility.#{api}.prenoms.maxItems"),
        items: { type: :string },
        example: SwaggerData.get("civility.#{api}.prenoms.example")
      },
      description: SwaggerData.get("civility.#{api}.prenoms.description"),
      required:
  end

  def parameters_identite_pivot_annee_date_naissance(required, api)
    parameter name: :anneeDateNaissance,
      in: :query,
      type: SwaggerData.get("civility.#{api}.anneeDateNaissance.type"),
      description: SwaggerData.get("civility.#{api}.anneeDateNaissance.description"),
      example: SwaggerData.get("civility.#{api}.anneeDateNaissance.example"),
      required:
  end

  def parameters_identite_pivot_mois_date_naissance(required, api)
    parameter name: :moisDateNaissance,
      in: :query,
      type: SwaggerData.get("civility.#{api}.moisDateNaissance.type"),
      description: SwaggerData.get("civility.#{api}.moisDateNaissance.description"),
      example: SwaggerData.get("civility.#{api}.moisDateNaissance.example"),
      required:
  end

  def parameters_identite_pivot_jour_date_naissance(required, api)
    parameter name: :jourDateNaissance,
      in: :query,
      type: SwaggerData.get("civility.#{api}.jourDateNaissance.type"),
      description: SwaggerData.get("civility.#{api}.jourDateNaissance.description"),
      example: SwaggerData.get("civility.#{api}.jourDateNaissance.example"),
      required:
  end

  def parameters_identite_pivot_code_cog_insee_commune_naissance(required, api)
    parameter name: :codeCogInseeCommuneNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get("civility.#{api}.codeCogInseeCommuneNaissance.type"),
        minLength: SwaggerData.get("civility.#{api}.codeCogInseeCommuneNaissance.minLength"),
        maxLength: SwaggerData.get("civility.#{api}.codeCogInseeCommuneNaissance.maxLength"),
        example: SwaggerData.get("civility.#{api}.codeCogInseeCommuneNaissance.example")
      },
      description: SwaggerData.get("civility.#{api}.codeCogInseeCommuneNaissance.description"),
      required:
  end

  def parameters_identite_pivot_code_cog_insee_pays_naissance(required, api)
    parameter name: :codeCogInseePaysNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get("civility.#{api}.codeCogInseePaysNaissance.type"),
        minLength: SwaggerData.get("civility.#{api}.codeCogInseePaysNaissance.minLength"),
        maxLength: SwaggerData.get("civility.#{api}.codeCogInseePaysNaissance.maxLength"),
        example: SwaggerData.get("civility.#{api}.codeCogInseePaysNaissance.example")
      },
      description: SwaggerData.get("civility.#{api}.codeCogInseePaysNaissance.description"),
      required:
  end

  def parameters_identite_pivot_sexe_etat_civil(required, api)
    parameter name: :sexeEtatCivil,
      in: :query,
      schema: {
        type: SwaggerData.get("civility.#{api}.sexeEtatCivil.type"),
        enum: SwaggerData.get("civility.#{api}.sexeEtatCivil.enum")
      },
      description: SwaggerData.get("civility.#{api}.sexeEtatCivil.description"),
      example: SwaggerData.get("civility.#{api}.sexeEtatCivil.example"),
      required:
  end

  def parameters_identite_pivot_nom_commune_naissance(required, api)
    parameter name: :nomCommuneNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get("civility.#{api}.nomCommuneNaissance.type"),
        minLength: SwaggerData.get("civility.#{api}.nomCommuneNaissance.minLength"),
        example: SwaggerData.get("civility.#{api}.nomCommuneNaissance.example")
      },
      description: SwaggerData.get("civility.#{api}.nomCommuneNaissance.description"),
      required:
  end

  def parameters_identite_pivot_code_cog_insee_departement_naissance(required, api)
    parameter name: :codeCogInseeDepartementNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get("civility.#{api}.codeCogInseeDepartementNaissance.type"),
        minLength: SwaggerData.get("civility.#{api}.codeCogInseeDepartementNaissance.minLength"),
        maxLength: SwaggerData.get("civility.#{api}.codeCogInseeDepartementNaissance.maxLength"),
        example: SwaggerData.get("civility.#{api}.codeCogInseeDepartementNaissance.example")
      },
      description: SwaggerData.get("civility.#{api}.codeCogInseeDepartementNaissance.description"),
      required:
  end

  def parameters_identite_pivot(params: [], required: [], api: 'commons')
    params.each do |param|
      public_send("parameters_identite_pivot_#{param.underscore}", required.include?(param), api)
    end
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def parameters_cnav_identite_pivot_v2
    parameter name: :nomUsage,
      in: :query,
      type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomUsage.type'),
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomUsage.description'),
      example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomUsage.example'),
      required: false

    parameter name: :nomNaissance,
      in: :query,
      type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomNaissance.type'),
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomNaissance.description'),
      example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomNaissance.example'),
      required: false

    parameter name: :'prenoms[]',
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.prenoms.type'),
        minItems: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.prenoms.minItems'),
        items: { type: :string },
        example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.prenoms.example')
      },
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.prenoms.description'),
      required: false

    parameter name: :anneeDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.anneeDateDeNaissance.type'),
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.anneeDateDeNaissance.description'),
      example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.anneeDateDeNaissance.example'),
      required: false

    parameter name: :moisDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.moisDateDeNaissance.type'),
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.moisDateDeNaissance.description'),
      example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.moisDateDeNaissance.example'),
      required: false

    parameter name: :jourDateDeNaissance,
      in: :query,
      type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.jourDateDeNaissance.type'),
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.jourDateDeNaissance.description'),
      example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.jourDateDeNaissance.example'),
      required: false

    parameter name: :codeInseeLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.type'),
        minLength: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.maxLength'),
        example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.example')
      },
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeLieuDeNaissance.description'),
      required: false

    parameter name: :codePaysLieuDeNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codePaysLieuDeNaissance.type'),
        minLength: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codePaysLieuDeNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codePaysLieuDeNaissance.maxLength'),
        example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codePaysLieuDeNaissance.example')
      },
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codePaysLieuDeNaissance.description'),
      required: false

    parameter name: :sexe,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.sexe.type'),
        enum: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.sexe.enum')
      },
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.sexe.description'),
      example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.sexe.example'),
      required: false

    parameter name: :nomCommuneNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomCommuneNaissance.type'),
        minLength: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomCommuneNaissance.minLength'),
        example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomCommuneNaissance.example')
      },
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.nomCommuneNaissance.description'),
      required: false

    parameter name: :codeInseeDepartementNaissance,
      in: :query,
      schema: {
        type: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeDepartementNaissance.type'),
        minLength: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeDepartementNaissance.minLength'),
        maxLength: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeDepartementNaissance.maxLength'),
        example: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeDepartementNaissance.example')
      },
      description: SwaggerData.get('cnav.v2.commons.cnav_identite_pivot.codeInseeDepartementNaissance.description'),
      required: false
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
# rubocop:enable Metrics/ModuleLength
