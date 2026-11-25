class BackfillEditorUseCasesFromFormUids < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      execute <<~SQL.squish
        INSERT INTO editor_use_cases (editor_id, form_uid, use_case, software, integration_status, created_at, updated_at)
        SELECT editors.id, form_uid, use_cases.use_case, editors.name, 'production', now(), now()
        FROM editors
        CROSS JOIN unnest(editors.form_uids) AS form_uid
        LEFT JOIN (VALUES #{use_case_by_form_uid}) AS use_cases (form_uid, use_case) USING (form_uid)
        ON CONFLICT DO NOTHING
      SQL
    end
  end

  def down
    safety_assured { execute('DELETE FROM editor_use_cases') }
  end

  private

  def use_case_by_form_uid
    YAML.load_file(Rails.root.join('config/datapass_use_cases.yml'))
      .values
      .flat_map { |use_cases| use_cases.flat_map { |use_case, form_uids| form_uids.map { |form_uid| [form_uid, use_case] } } }
      .map { |form_uid, use_case| "(#{connection.quote(form_uid)}, #{connection.quote(use_case)})" }
      .join(', ')
  end
end
