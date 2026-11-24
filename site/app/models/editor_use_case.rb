class EditorUseCase < ApplicationRecord
  INTEGRATION_STATUSES = %w[production recette development prospection].freeze

  belongs_to :editor

  normalizes :form_uid, with: ->(value) { value.strip.presence }
  normalizes :scopes, with: ->(scopes) { scopes.compact_blank.uniq.sort }

  validates :use_case, presence: true
  validates :software, presence: true
  validates :integration_status, inclusion: { in: INTEGRATION_STATUSES }
  validates :data_retention_months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :form_uid, uniqueness: true, allow_nil: true

  scope :with_form, -> { where.not(form_uid: nil) }
  scope :awaiting_datapass_completion, -> { with_form.where(use_case: nil) }

  def self.integration_status_options
    INTEGRATION_STATUSES.map { |status| [I18n.t(status, scope: 'editor_use_cases.integration_statuses'), status] }
  end

  def datapass_use_case
    DatapassUseCase.find(use_case) if use_case
  end

  def datapass_form
    DatapassForm.find_by(uid: form_uid) if form_uid
  end

  def label
    use_case ? DatapassUseCase.label_for(use_case) : I18n.t('editor_use_cases.unknown_use_case')
  end

  def complete_from_datapass_form!
    form = datapass_form
    return if form&.use_case.nil?

    update!(
      use_case: form.use_case,
      software: editor.name,
      scopes: form.scopes,
      data_retention_months: form.data_retention_months,
      data_recipients: form.data_recipients
    )
  end
end
