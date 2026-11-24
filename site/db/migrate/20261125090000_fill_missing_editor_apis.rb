class FillMissingEditorApis < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      fill_from_form_prefixes
      fill_from_creation_namespace
    end
  end

  def down; end

  private

  def fill_from_form_prefixes
    execute <<~SQL.squish
      UPDATE editors
      SET apis = derived.apis
      FROM (
        SELECT editors.id, array_agg(DISTINCT substring(form_uid FROM '^api-(entreprise|particulier)'))::varchar[] AS apis
        FROM editors, unnest(editors.form_uids) AS form_uid
        WHERE cardinality(editors.apis) = 0
          AND form_uid ~ '^api-(entreprise|particulier)'
        GROUP BY editors.id
      ) derived
      WHERE editors.id = derived.id
    SQL
  end

  def fill_from_creation_namespace
    execute <<~SQL.squish
      UPDATE editors
      SET apis = ARRAY[creation.namespace]::varchar[]
      FROM admin_activities creation
      WHERE cardinality(editors.apis) = 0
        AND creation.entity_type = 'Editor'
        AND creation.entity_id = editors.id
        AND creation.name = 'editor_created'
        AND creation.namespace IN ('entreprise', 'particulier')
    SQL
  end
end
