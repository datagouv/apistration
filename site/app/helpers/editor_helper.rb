module EditorHelper
  ROLE_CONFIG = {
    'manages_token' => { label: 'Gère le jeton', badge: 'green-emeraude' },
    'client_manages_token' => { label: 'Client gère le jeton', badge: 'blue-cumulus' },
    'both' => { label: 'Les deux', badge: 'yellow-tournesol' }
  }.freeze

  ROLE_OPTIONS = [['Inconnu', '']] + ROLE_CONFIG.map { |k, v| [v[:label], k] }

  DEPLOYMENT_CONFIG = {
    'saas' => { label: 'SaaS', badge: 'blue-cumulus' },
    'on_premise' => { label: 'On-premise', badge: 'purple-glycine' },
    'both' => { label: 'Les deux', badge: 'yellow-tournesol' }
  }.freeze

  DEPLOYMENT_OPTIONS = [['Inconnu', '']] + DEPLOYMENT_CONFIG.map { |k, v| [v[:label], k] }

  def editor_role_badge(editor)
    return content_tag(:p, 'Rôle inconnu', class: 'fr-badge') unless editor.role

    config = ROLE_CONFIG[editor.role]
    content_tag(:p, config[:label], class: "fr-badge fr-badge--#{config[:badge]}")
  end

  def editor_role_badge_sm(editor)
    return unless editor.role

    config = ROLE_CONFIG[editor.role]
    content_tag(:p, config[:label], class: "fr-badge fr-badge--sm fr-badge--#{config[:badge]}")
  end

  def editor_deployment_badge(editor)
    return content_tag(:p, 'Déploiement inconnu', class: 'fr-badge') unless editor.deployment_type

    config = DEPLOYMENT_CONFIG[editor.deployment_type]
    content_tag(:p, config[:label], class: "fr-badge fr-badge--#{config[:badge]}")
  end

  def editor_deployment_badge_sm(editor)
    return unless editor.deployment_type

    config = DEPLOYMENT_CONFIG[editor.deployment_type]
    content_tag(:p, config[:label], class: "fr-badge fr-badge--sm fr-badge--#{config[:badge]}")
  end

  def editor_role_label(editor)
    ROLE_CONFIG.dig(editor.role, :label) || 'Inconnu'
  end

  def editor_deployment_label(editor)
    DEPLOYMENT_CONFIG.dig(editor.deployment_type, :label) || 'Inconnu'
  end
end
