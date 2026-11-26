class EditorUseCase < ApplicationRecord
  EDITABLE_ATTRIBUTES = [
    :use_case, :software, :software_description, :software_url, :data_retention_months, :data_recipients, :setup_instructions,
    :security_accreditation, :security_accreditation_begin_date, :security_accreditation_end_date, :mon_service_securise_url,
    { scopes: [] }
  ].freeze
  ADMIN_ATTRIBUTES = [:form_uid].freeze

  belongs_to :editor

  normalizes :form_uid, with: ->(value) { value.strip.presence }
  normalizes :scopes, with: ->(scopes) { scopes.compact_blank.uniq.sort }
  normalizes :mon_service_securise_url, :software_url, with: ->(url) { url.strip.presence }

  before_validation :clear_security_accreditation_dates, unless: :security_accreditation?

  validates :use_case, presence: true
  validates :software, presence: true
  validates :data_retention_months, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :form_uid, uniqueness: true, allow_nil: true
  validates :security_accreditation_begin_date, :security_accreditation_end_date, presence: true, if: :security_accreditation?
  validates :security_accreditation_end_date, comparison: { greater_than: :security_accreditation_begin_date }, if: -> { security_accreditation_begin_date && security_accreditation_end_date }
  validates :mon_service_securise_url, :software_url, web_address: true
  validate :use_case_in_referential, if: :use_case_changed?

  before_update :mark_as_edited

  scope :with_form, -> { where.not(form_uid: nil) }

  def self.prefill(use_case, key)
    return use_case.prefill_from_datapass_form if key.blank? || use_case.use_case.present?

    use_case.assign_attributes(use_case: key, scopes: DatapassUseCase.find(key)&.default_scopes || [])
    use_case
  end

  def datapass_use_case
    DatapassUseCase.find(use_case) if use_case
  end

  def datapass_form
    DatapassReferential.new(api).form(form_uid) if form_uid && api
  end

  def label
    use_case ? DatapassUseCase.label_for(use_case) : I18n.t('editor_use_cases.unknown_use_case')
  end

  def api
    datapass_use_case&.api
  end

  def scope_catalogue
    DatapassReferential.new(api).scopes&.reject(&:deprecated) if api
  end

  def scope_groups
    split_scope_groups.first
  end

  def other_scope_groups
    split_scope_groups.last
  end

  def prefill_from_datapass_form
    form = datapass_form if scopes.empty? && never_edited?
    return self unless form

    assign_attributes(
      scopes: form.scopes,
      data_retention_months: data_retention_months || form.data_retention_months,
      data_recipients: data_recipients.presence || form.data_recipients
    )
    self
  end

  private

  def clear_security_accreditation_dates
    self.security_accreditation_begin_date = nil
    self.security_accreditation_end_date = nil
  end

  def mark_as_edited
    self.updated_at = Time.current
  end

  def never_edited?
    persisted? && updated_at == created_at
  end

  def split_scope_groups
    @split_scope_groups ||= begin
      expected_scopes = scopes | datapass_use_case&.scope_values.to_a
      groups = scope_options_by_group

      expected_scopes.any? ? partition_scope_groups(groups, expected_scopes) : [groups, {}]
    end
  end

  def partition_scope_groups(groups, expected_scopes)
    groups.partition { |_group, options| options.any? { |_label, value| expected_scopes.include?(value) } }.map(&:to_h)
  end

  def scope_options_by_group
    catalogue = scope_catalogue.to_a
    groups = catalogue.group_by(&:group).transform_values { |group_scopes| group_scopes.map { |scope| [scope.label, scope.value] } }

    groups.merge('Autres données' => unknown_scope_options(catalogue)) { |_group, known, unknown| known + unknown }.compact_blank
  end

  def unknown_scope_options(catalogue)
    (scopes - catalogue.map(&:value)).map { |scope| [scope, scope] }
  end

  def use_case_in_referential
    errors.add(:use_case, :inclusion) if use_case && !DatapassUseCase.find(use_case)
  end
end
