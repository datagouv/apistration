class ScopeBackfillService
  TABLES = %w[tokens authorization_requests].freeze

  def initialize(added_scope:, when_any_of:, executor: ActiveRecord::Base.connection)
    @binds = { added_scope:, trigger_scopes: Array(when_any_of) }
    @executor = executor
  end

  def up
    update_scopes(<<~SQL.squish)
      SET scopes = scopes || jsonb_build_array(:added_scope::text)
      WHERE scopes ?| ARRAY[:trigger_scopes]::text[]
      AND NOT scopes ? :added_scope
    SQL
  end

  def down
    update_scopes(<<~SQL.squish)
      SET scopes = scopes - :added_scope::text
      WHERE scopes ? :added_scope
    SQL
  end

  private

  def update_scopes(statement)
    TABLES.each do |table|
      @executor.execute(ActiveRecord::Base.sanitize_sql_array(["UPDATE #{table} #{statement}", @binds]))
    end
  end
end
