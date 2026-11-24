EditorProfileSection = Data.define(:key, :editor_attributes, :admin_attributes) do
  def self.all
    [
      new(key: 'general', editor_attributes: %i[name description domain], admin_attributes: [:siret, :role, { apis: [] }]),
      new(key: 'contacts', editor_attributes: %i[contact_email contact_phone], admin_attributes: []),
      new(key: 'security', editor_attributes: %i[deployment_type], admin_attributes: %i[allowed_ips]),
      new(key: 'technical', editor_attributes: %i[languages setup_instructions], admin_attributes: %i[copy_token editor_tokens_enabled])
    ]
  end

  def self.find(key)
    all.find { |section| section.key == key } || all.first
  end

  def label
    I18n.t(key, scope: 'editor_profile.sections')
  end

  def permitted_attributes(admin:)
    admin ? editor_attributes + admin_attributes : editor_attributes
  end
end
