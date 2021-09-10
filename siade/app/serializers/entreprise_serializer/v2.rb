class EntrepriseSerializer::V2 < ActiveModel::Serializer
  attributes :siren, :capital_social, :numero_tva_intracommunautaire,
    :forme_juridique, :forme_juridique_code,
    :nom_commercial, :procedure_collective, :enseigne,
    :libelle_naf_entreprise, :naf_entreprise,
    :raison_sociale, :siret_siege_social, :code_effectif_entreprise,
    :date_creation, :nom, :prenom, :date_radiation,
    :categorie_entreprise, :tranche_effectif_salarie_entreprise,
    :mandataires_sociaux, :etat_administratif
  attribute :diffusable_commercialement?, key: :diffusable_commercialement, if: :with_non_diffusable?

  def initialize(object, options = {})
    @options = options
    super(object, options)
  end

  def with_non_diffusable?
    @options[:with_non_diffusable]
  end

  # attribute renamed to keep consistency in lib and clarity in JSON response
  def libelle_naf_entreprise
    object.libelle_naf
  end

  # attribute renamed to keep consistency in lib and clarity in JSON response
  def naf_entreprise
    object.naf
  end
end
