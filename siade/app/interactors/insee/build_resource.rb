class INSEE::BuildResource < BuildResource
  protected

  STATUT_DIFFUSION = {
    'O' => :diffusible,
    'N' => :non_diffusible,
    'P' => :partiellement_diffusible
  }.freeze

  def date_to_timestamp(value)
    return if value.nil?

    Date.parse(value).to_time.to_i
  end

  def yes_no_to_boolean(value)
    value && value == 'O'
  end

  def referential(name, params)
    SIADE::V2::Referentials.const_get(name.classify).new(**params).as_json
  end
end
