class INSEE::BuildResource < BuildResource
  protected

  STATUT_DIFFUSION = {
    'O' => :diffusible,
    'N' => :non_diffusible,
    'P' => :partiellement_diffusible
  }.freeze

  def diffusable_commercialement(status_diffusion)
    STATUT_DIFFUSION[status_diffusion] == :diffusible
  end

  def date_to_timestamp(value)
    return if value.nil?

    Date.parse(value).to_time.to_i
  end

  def yes_no_to_boolean(value)
    value && value == 'O'
  end

  def referential(name, params)
    Referentials.const_get(name.classify).new(**params).as_json
  end

  def activite_principale_naf2025_from(code:, nomenclature:, naf2025_code:)
    Referentials::ActivitePrincipale.new(
      code: naf2025_code || (code if naf2025_code?(code:, nomenclature:)),
      nomenclature: 'NAF2025'
    )
  end

  def activite_principale_naf_rev2_from(code:, nomenclature:)
    Referentials::ActivitePrincipale.new(
      code: nafrev2_code(code:, nomenclature:),
      nomenclature: 'NAFRev2'
    )
  end

  private

  def nafrev2_code(code:, nomenclature:)
    return code unless naf2025_code?(code:, nomenclature:)

    Referentials::ActivitePrincipale.unambiguous_nafrev2_for_naf2025[code]
  end

  def naf2025_code?(code:, nomenclature:)
    nomenclature == 'NAF25' || Referentials::ActivitePrincipale.naf2025.key?(code)
  end
end
