module EditorDelegationRequestsHelper
  DATA_SUBJECTS = {
    'entreprise' => 'des données sur les entreprises',
    'particulier' => 'des données sur les particuliers'
  }.freeze

  def of_editor(editor)
    name = editor.name.strip

    name.match?(/\A[aeiouyhâàéèêëîïôûù]/i) ? "d’#{name}" : "de #{name}"
  end

  def delegation_api_name(batch)
    "API #{batch.api.capitalize}"
  end

  def delegation_data_subject(batch)
    DATA_SUBJECTS.fetch(batch.api)
  end

  def proconnect_login_path(batch)
    public_send(:"login_proconnect_#{batch.api}_path")
  end
end
