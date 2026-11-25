EditorProfileSection = Data.define(:key, :editor_attributes, :admin_attributes) do
  def self.all
    [
      new(key: 'general', editor_attributes: %i[name description domain], admin_attributes: [:siret, :role, :copy_token, :editor_tokens_enabled, { apis: [] }]),
      new(key: 'contacts', editor_attributes: [], admin_attributes: []),
      new(key: 'security', editor_attributes: security_attributes, admin_attributes: %i[allowed_ips]),
      new(key: 'use_cases', editor_attributes: [], admin_attributes: [])
    ]
  end

  def self.security_attributes
    [
      :deployment_type, :hosting_provider, :hosting_country,
      :two_factor_status, :two_factor_deadline, { two_factor_methods: [] }
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
