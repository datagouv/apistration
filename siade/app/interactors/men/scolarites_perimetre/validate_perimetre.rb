class MEN::ScolaritesPerimetre::ValidatePerimetre < ValidateParamInteractor
  PERIMETRE_MAPPING = {
    codes_cog_insee_communes: 'commune',
    codes_bcn_departements: 'departement',
    codes_bcn_regions: 'region',
    identifiants_siren_intercommunalites: 'communaute_commune'
  }.freeze

  VALIDATORS = {
    codes_cog_insee_communes: MEN::ScolaritesPerimetre::Validators::CommuneValidator,
    codes_bcn_departements: MEN::ScolaritesPerimetre::Validators::DepartementValidator,
    codes_bcn_regions: MEN::ScolaritesPerimetre::Validators::RegionValidator,
    identifiants_siren_intercommunalites: MEN::ScolaritesPerimetre::Validators::SirenIntercommunaliteValidator
  }.freeze

  def call
    provided = provided_perimetres

    return invalid_param!(:perimetre) if provided.size != 1

    perimetre_key, values = provided.first

    return invalid_param!(:perimetre_valeurs) unless valid_array?(values)
    return invalid_param!(perimetre_key) unless VALIDATORS.fetch(perimetre_key).valid?(values)

    context.perimetre_type = PERIMETRE_MAPPING.fetch(perimetre_key)
    context.perimetre_valeurs = values
  end

  private

  def valid_array?(values)
    values.present? && values == [*values] && values.none?(&:blank?)
  end

  def provided_perimetres
    PERIMETRE_MAPPING.keys.filter_map do |key|
      value = param(key)
      [key, value] if value.present?
    end
  end
end
