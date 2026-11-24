class DatapassReferentialSync
  def initialize(api, client: DatapassAPIClient.new)
    @api = api
    @client = client
  end

  def call
    synced_at = Time.current

    sync_forms(synced_at)
    sync_scopes(synced_at)
  end

  private

  attr_reader :api, :client

  def definition_id
    "api_#{api}"
  end

  def sync_forms(synced_at)
    rows = client.list_formulaires(definition_id).map { |form| form_row(form, synced_at) }
    return if rows.empty?

    rows.each { |row| DatapassForm.find_or_initialize_by(uid: row[:uid]).update!(row) }
    DatapassForm.for_api(api).where(synced_at: ...synced_at).delete_all
  end

  def sync_scopes(synced_at)
    rows = client.get_definition(definition_id).fetch('scopes', []).map { |scope| scope_row(scope, synced_at) }
    return if rows.empty?

    rows.each { |row| DatapassScope.find_or_initialize_by(api:, value: row[:value]).update!(row) }
    DatapassScope.for_api(api).where(synced_at: ...synced_at).delete_all
  end

  def form_row(form, synced_at)
    data = form['data'].presence || {}

    {
      uid: form['uid'],
      api:,
      use_case: form['use_case'].presence,
      name: form['name'],
      description: form['description'],
      scopes: Array(data['scopes']),
      data:,
      synced_at:
    }
  end

  def scope_row(scope, synced_at)
    {
      api:,
      value: scope['value'],
      name: scope['name'],
      group: scope['group'],
      deprecated: scope['deprecated'] == true,
      synced_at:
    }
  end
end
