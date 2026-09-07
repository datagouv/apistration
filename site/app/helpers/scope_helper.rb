module ScopeHelper
  UNKNOWN_SCOPE_GROUP = 'Autres'.freeze

  def build_scopes(scopes, api)
    scopes_tree = {}
    scopes.each do |scope|
      splitted_scope = humanize_scope(scope, api).split('||').map(&:strip)
      build_scopes_parts(scopes_tree, splitted_scope)
    end
    scopes_tree
  end

  def humanize_scope(scope, api)
    entry = ScopeCatalog.for(api).lookup(scope)
    scope_display_parts(api, entry, scope).join(' || ')
  end

  private

  def scope_display_parts(api, entry, scope)
    name = entry&.dig(:name).presence || scope.humanize
    provider = entry&.dig(:provider).presence || UNKNOWN_SCOPE_GROUP
    if api == 'api_particulier'
      group = entry&.dig(:group).presence || UNKNOWN_SCOPE_GROUP
      [provider, group, name]
    else
      [provider, name]
    end
  end

  def build_scopes_parts(scopes_tree, splitted_scope) # rubocop:disable Metrics/AbcSize, Metrics/PerceivedComplexity
    if splitted_scope.size > 2
      scopes_tree[splitted_scope[0]] ||= {}
      build_scopes_parts(scopes_tree[splitted_scope[0]], splitted_scope[1..])
    elsif splitted_scope.size > 1
      if scopes_tree[splitted_scope[0]].is_a?(Hash)
        scopes_tree[splitted_scope[0]][splitted_scope[1]] ||= []
      else
        scopes_tree[splitted_scope[0]] ||= []
        scopes_tree[splitted_scope[0]].push(splitted_scope[1])
      end
    end
  end
end
