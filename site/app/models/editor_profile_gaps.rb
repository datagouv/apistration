class EditorProfileGaps
  Gap = Data.define(:section_key, :label)

  def initialize(editor)
    @editor = editor
  end

  def all
    @all ||= [*contact_gaps, *security_gaps, *use_case_gaps]
  end

  def for_section(section_key)
    all.select { |gap| gap.section_key == section_key }
  end

  delegate :any?, :size, to: :all

  private

  attr_reader :editor

  def contact_gaps
    roles = editor.contacts.map(&:role)

    {
      'technical' => 'un contact technique',
      'security' => 'un contact Sécurité (RSSI)'
    }.except(*roles).map { |_role, label| Gap.new(section_key: 'contacts', label:) }
  end

  def security_gaps
    {
      'la double authentification de vos usagers' => editor.two_factor_status.nil?,
      'la gestion des jetons' => editor.credentials_management.blank?
    }.select { |_label, missing| missing }.map { |label, _missing| Gap.new(section_key: 'security', label:) }
  end

  def use_case_gaps
    use_cases = editor.use_cases.to_a
    return [Gap.new(section_key: 'use_cases', label: 'au moins une démarche')] if use_cases.empty?

    incomplete = use_cases.count { |use_case| use_case.use_case.nil? || use_case.scopes.empty? || use_case.security_accreditation.nil? }
    return [] if incomplete.zero?

    [Gap.new(section_key: 'use_cases', label: "#{incomplete} #{incomplete > 1 ? 'démarches' : 'démarche'} à compléter")]
  end
end
