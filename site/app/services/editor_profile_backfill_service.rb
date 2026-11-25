class EditorProfileBackfillService
  def initialize(executor: ActiveRecord::Base.connection, use_cases_file: Rails.root.join('config/datapass_use_cases.yml'))
    @executor = executor
    @use_cases_file = use_cases_file
  end

  def fill_missing_apis
    fill_apis_from_form_prefixes
    fill_apis_from_creation_namespace
  end

  def fill_apis_from_form_prefixes
    execute(<<~SQL.squish)
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

  def fill_apis_from_creation_namespace
    execute(<<~SQL.squish)
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

  def create_use_cases_from_form_uids
    execute(<<~SQL.squish)
      INSERT INTO editor_use_cases (editor_id, form_uid, use_case, software, setup_instructions, created_at, updated_at)
      SELECT editors.id, form_uid, use_cases.use_case, editors.name, editors.setup_instructions, now(), now()
      FROM editors
      CROSS JOIN unnest(editors.form_uids) AS form_uid
      LEFT JOIN (VALUES #{use_case_by_form_uid}) AS use_cases (form_uid, use_case) USING (form_uid)
      ON CONFLICT DO NOTHING
    SQL
  end

  def remove_use_cases
    execute('DELETE FROM editor_use_cases')
  end

  def move_contacts_to_technical_contacts
    execute(<<~SQL.squish)
      INSERT INTO editor_contacts (editor_id, role, email, phone, created_at, updated_at)
      SELECT id, 'technical', NULLIF(contact_email, ''), NULLIF(contact_phone, ''), now(), now()
      FROM editors
      WHERE COALESCE(contact_email, '') <> '' OR COALESCE(contact_phone, '') <> ''
    SQL
  end

  def remove_technical_contacts
    execute("DELETE FROM editor_contacts WHERE role = 'technical'")
  end

  private

  attr_reader :executor, :use_cases_file

  def execute(statement)
    executor.execute(statement)
  end

  def use_case_by_form_uid
    YAML.load_file(use_cases_file)
      .values
      .flat_map { |use_cases| use_cases.flat_map { |use_case, form_uids| form_uids.map { |form_uid| [form_uid, use_case] } } }
      .map { |form_uid, use_case| "(#{executor.quote(form_uid)}, #{executor.quote(use_case)})" }
      .join(', ')
  end
end
