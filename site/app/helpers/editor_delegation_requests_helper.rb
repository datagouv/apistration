module EditorDelegationRequestsHelper
  DATA_SUBJECTS = {
    'entreprise' => 'des données sur les entreprises',
    'particulier' => 'des données sur les particuliers'
  }.freeze

  DELEGATION_STEPS = ['S’identifier', 'Compléter le DPD', 'Vérifier et soumettre'].freeze

  def delegation_stepper(step)
    dsfr_stepper(current_step: DELEGATION_STEPS.fetch(step), steps: DELEGATION_STEPS)
  end

  def delegation_legal_frame(batch)
    batch.datapass_data.slice('cadre_juridique_nature', 'cadre_juridique_url').compact_blank
  rescue DatapassAPIClient::Error, DatapassFormulaire::NotFound
    {}
  end

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
