class MI::Associations::PayloadParser
  SINGLE_ELEMENT_COLLECTIONS = {
    etablissements: :etablissement,
    agrements: :agrement,
    affiliations: :affiliation,
    compositions: :membre,
    dirigeants: :representant_legal
  }.freeze

  EXPLODED_COLLECTIONS = {
    comptes: :compte,
    rhs: :rh
  }.freeze

  def self.call(body)
    new(body).call
  end

  def initialize(body)
    @body = body
  end

  def call
    asso = normalize(JSON.parse(@body, symbolize_names: true))

    { asso: asso.is_a?(Hash) ? wrap_collections(asso) : asso }
  end

  private

  def normalize(value)
    case value
    when Hash  then value.transform_values { |v| normalize(v) }
    when Array then value.map { |v| normalize(v) }
    else normalize_scalar(value)
    end
  end

  def normalize_scalar(value)
    case value
    when true, false, Numeric then value.to_s
    when String then value.gsub(/\s+/, ' ').strip.presence
    end
  end

  def wrap_collections(asso)
    SINGLE_ELEMENT_COLLECTIONS.each { |plural, singular| wrap_collection!(asso, plural, singular) }
    EXPLODED_COLLECTIONS.each { |plural, singular| wrap_collection!(asso, plural, singular) { |list| explode(list) } }

    asso
  end

  def wrap_collection!(asso, plural, singular)
    return unless asso[plural].is_a?(Array) && asso[plural].any?

    list = asso[plural]
    asso[plural] = { singular => block_given? ? yield(list) : list }
  end

  def explode(list)
    exploded = list.map { |entry| entry.map { |key, value| { key => value } } }
    exploded.one? ? exploded.first : exploded
  end
end
