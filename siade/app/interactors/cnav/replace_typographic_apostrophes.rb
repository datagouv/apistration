class CNAV::ReplaceTypographicApostrophes < ApplicationInteractor
  NAME_PARAMS = %i[nom_naissance nom_usage prenoms].freeze

  def call
    NAME_PARAMS.each do |name|
      context.params[name] = replace_typographic_apostrophes(context.params[name])
    end
  end

  private

  def replace_typographic_apostrophes(value)
    return value.map { |item| replace_typographic_apostrophes(item) } if [*value] == value

    value&.tr('’', "'")
  end
end
