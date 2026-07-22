class BackfillEditorApis < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    safety_assured do
      execute(<<~SQL.squish)
        UPDATE editors
        SET apis = sub.apis
        FROM (
          SELECT id, array_agg(DISTINCT split_part(form_uid, '-', 2)) AS apis
          FROM editors, unnest(form_uids) AS form_uid
          WHERE form_uid LIKE 'api-entreprise-%' OR form_uid LIKE 'api-particulier-%'
          GROUP BY id
        ) AS sub
        WHERE editors.id = sub.id
      SQL
    end
  end

  def down
    safety_assured { execute("UPDATE editors SET apis = '{}'") }
  end
end
