class CNAV::IdentityParamsShape
  NAME_PARAMS = %i[nom_naissance nom_usage prenoms].freeze
  CODE_PARAMS = %i[code_cog_insee_commune_naissance code_cog_insee_departement_naissance code_cog_insee_pays_naissance].freeze

  NAME_TRAITS = {
    apostrophe: /['’`]/,
    hyphen: /-/,
    inner_space: /\S\s+\S/,
    edge_space: /\A\s|\s\z/,
    double_space: /\s{2}/,
    digit: /\d/,
    lowercase: /\p{Lower}/,
    accent: /[À-ÖØ-öø-ÿ]/,
    other: /[^\p{L}\d'’` -]/
  }.freeze

  def initialize(params)
    @params = params.to_h.with_indifferent_access
  end

  def to_h
    NAME_PARAMS.index_with { |name| name_shape(@params[name]) }
      .merge(CODE_PARAMS.index_with { |name| code_shape(@params[name]) })
      .compact
  end

  private

  def name_shape(value)
    return if value.blank?

    [*value].map { |name| describe_name(name.to_s) }.join(' | ')
  end

  def describe_name(name)
    traits = NAME_TRAITS.select { |_, pattern| name.match?(pattern) }.keys
    traits << :non_transliterable if ActiveSupport::Inflector.transliterate(name).include?('?')

    "#{name.length}:#{traits.join(',')}"
  end

  def code_shape(value)
    return if value.blank?

    "#{value.to_s.length}:#{value.to_s[0, 2]}"
  end
end
