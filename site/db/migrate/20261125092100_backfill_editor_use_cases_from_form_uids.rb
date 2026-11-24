class BackfillEditorUseCasesFromFormUids < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      execute <<~SQL.squish
        INSERT INTO editor_use_cases (editor_id, form_uid, integration_status, created_at, updated_at)
        SELECT editors.id, form_uid, 'production', now(), now()
        FROM editors, unnest(editors.form_uids) AS form_uid
        ON CONFLICT DO NOTHING
      SQL
    end
  end

  def down
    safety_assured { execute('DELETE FROM editor_use_cases') }
  end
end
