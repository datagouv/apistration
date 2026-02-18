class MEN::ScolaritesPerimetre::ValidatePerimetre < ValidateParamInteractor
  PERIMETRE_MAPPING = {
    codes_cog_insee_communes: 'commune',
    codes_bcn_men_departements: 'departement',
    codes_bcn_men_regions: 'region',
    identifiants_siren_intercommunalites: 'communaute_commune'
  }.freeze

  def call
    provided = provided_perimetres

    return invalid_param!(:perimetre) if provided.size != 1

    perimetre_key, values = provided.first

    return invalid_param!(:perimetre_valeurs) if values.blank? || !values.is_a?(Array) || values.any?(&:blank?)

    context.perimetre_type = PERIMETRE_MAPPING.fetch(perimetre_key)
    context.perimetre_valeurs = values
  end

  private

  def provided_perimetres
    PERIMETRE_MAPPING.keys.filter_map do |key|
      value = param(key)
      [key, value] if value.present?
    end
  end
end
