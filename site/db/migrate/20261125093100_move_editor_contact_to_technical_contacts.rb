class MoveEditorContactToTechnicalContacts < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      execute <<~SQL.squish
        INSERT INTO editor_contacts (editor_id, role, email, phone, created_at, updated_at)
        SELECT id, 'technical', NULLIF(contact_email, ''), NULLIF(contact_phone, ''), now(), now()
        FROM editors
        WHERE COALESCE(contact_email, '') <> '' OR COALESCE(contact_phone, '') <> ''
      SQL
    end
  end

  def down
    safety_assured { execute("DELETE FROM editor_contacts WHERE role = 'technical'") }
  end
end
