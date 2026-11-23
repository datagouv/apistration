module EditorDelegationRequestsHelper
  def of_editor(editor)
    name = editor.name.strip

    name.match?(/\A[aeiouyhâàéèêëîïôûù]/i) ? "d’#{name}" : "de #{name}"
  end

  def scope_with_provider(scope)
    provider, api = humanize_scope(scope, 'entreprise').split('||').map(&:strip)

    api ? "#{api} (#{provider})" : provider
  end
end
