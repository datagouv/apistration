class DatapassUseCase
  EXCLUDED_KEYS = %w[specific_editeurs].freeze

  attr_reader :api, :key, :forms

  def self.for_api(api)
    DatapassForm.for_api(api)
      .where.not(use_case: [nil, *EXCLUDED_KEYS])
      .order(:uid)
      .group_by(&:use_case)
      .map { |key, forms| new(api:, key:, forms:) }
      .sort_by(&:label)
  end

  def self.for_apis(apis)
    apis.flat_map { |api| for_api(api) }
  end

  def self.find(key)
    forms = DatapassForm.where(use_case: key).order(:uid).to_a
    new(api: forms.first.api, key:, forms:) if forms.any?
  end

  def initialize(api:, key:, forms:)
    @api = api
    @key = key
    @forms = forms
  end

  def label
    self.class.label_for(key)
  end

  def self.label_for(key)
    I18n.t(key, scope: 'datapass_use_cases', default: key.to_s.tr('_-', ' ').capitalize)
  end

  def default_scopes
    generic_forms = forms.reject(&:editor_specific?).presence || forms

    generic_forms
      .map { |form| form.scopes.sort }
      .tally
      .max_by { |scopes, count| [count, -scopes.size] }
      .first
  end
end
