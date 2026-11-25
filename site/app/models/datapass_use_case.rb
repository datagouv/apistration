class DatapassUseCase
  attr_reader :api, :key, :form_uids

  def self.all
    @all ||= YAML.load_file(Rails.root.join('config/datapass_use_cases.yml')).flat_map do |api, use_cases|
      use_cases.map { |key, form_uids| new(api:, key:, form_uids:) }
    end
  end

  def self.for_api(api)
    all.select { |use_case| use_case.api == api }.sort_by(&:label)
  end

  def self.for_apis(apis)
    apis.flat_map { |api| for_api(api) }
  end

  def self.find(key)
    all.find { |use_case| use_case.key == key }
  end

  def self.for_form(form_uid)
    all.find { |use_case| use_case.form_uids.include?(form_uid) }
  end

  def self.label_for(key)
    I18n.t(key, scope: 'datapass_use_cases', default: key.to_s.tr('_-', ' ').capitalize)
  end

  def initialize(api:, key:, form_uids:)
    @api = api
    @key = key
    @form_uids = form_uids
  end

  def label
    self.class.label_for(key)
  end

  def default_scopes
    most_common_scopes = generic_forms.map { |form| form.scopes.sort }.tally.max_by { |scopes, count| [count, -scopes.size] }

    most_common_scopes ? most_common_scopes.first : []
  end

  def scope_values
    generic_forms.flat_map(&:scopes).uniq
  end

  private

  def generic_forms
    forms = DatapassReferential.new(api).forms.select { |form| form_uids.include?(form.uid) }

    forms.reject(&:editor_specific?).presence || forms
  end
end
