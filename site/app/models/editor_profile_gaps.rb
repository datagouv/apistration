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
    [
      ('la double authentification de vos usagers' if editor.two_factor_status.nil?),
      ('votre homologation de sécurité' if editor.security_accreditation.nil?)
    ].compact.map { |label| Gap.new(section_key: 'security', label:) }
  end

  def use_case_gaps
    use_cases = editor.use_cases.to_a
    return [Gap.new(section_key: 'use_cases', label: "au moins un cas d'usage")] if use_cases.empty?

    incomplete = use_cases.count { |use_case| use_case.use_case.nil? || use_case.scopes.empty? }
    return [] if incomplete.zero?

    [Gap.new(section_key: 'use_cases', label: "#{incomplete} cas d'usage à compléter")]
  end
end
