class ChangelogEntry
  include ActiveModel::Model

  SCOPES = %w[api_entreprise api_particulier both].freeze

  attr_accessor :date, :scope, :title, :description

  def self.all
    load_entries
  end

  def self.for(api)
    all.select { |entry| entry.relevant_for?(api) }
  end

  def self.grouped_by_year_for(api)
    self.for(api).group_by { |entry| entry.date.year }.sort.reverse.to_h
  end

  def relevant_for?(api)
    scope == api.to_s || scope == 'both'
  end

  def both?
    scope == 'both'
  end

  def self.load_entries
    return @entries if defined?(@entries) && Rails.configuration.cache_classes

    raw = YAML.safe_load_file(file_path, permitted_classes: [Date])

    @entries = raw.map { |attrs| new(**attrs.symbolize_keys) }
      .each(&:validate_scope!)
      .sort_by { |entry| [entry.date, entry.title] }
      .reverse
  end

  def self.file_path
    Rails.root.join('config/changelogs.yml')
  end

  def validate_scope!
    return if SCOPES.include?(scope)

    raise ArgumentError, "ChangelogEntry: invalid scope #{scope.inspect} for #{title.inspect} (allowed: #{SCOPES.join(', ')})"
  end
end
