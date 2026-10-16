class APIParticulier::FacilitatorUseCase
  attr_reader :key, :label, :forms

  def self.all
    @all ||= YAML.load_file(Rails.root.join('config/api_particulier_facilitators.yml'))
      .fetch('use_cases')
      .map { |key, attributes| new(key:, label: attributes.fetch('label'), forms: attributes.fetch('forms')) }
  end

  def self.find(key)
    all.find { |use_case| use_case.key == key }
  end

  def self.for_form_uid(form_uid)
    all.find { |use_case| use_case.forms.key?(form_uid) }
  end

  def initialize(key:, label:, forms:)
    @key = key
    @label = label
    @forms = forms
  end

  def form_uids
    forms.keys
  end

  def form_label(form_uid)
    forms.fetch(form_uid)
  end
end
