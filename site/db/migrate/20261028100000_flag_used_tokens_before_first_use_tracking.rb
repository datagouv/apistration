class FlagUsedTokensBeforeFirstUseTracking < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def up
    safety_assured do
      execute(<<~SQL.squish)
        UPDATE tokens
        SET used = true
        WHERE id IN (
          SELECT tokens.id FROM tokens
          CROSS JOIN LATERAL (SELECT 1 FROM access_logs WHERE access_logs.token_id = tokens.id LIMIT 1) first_call
          WHERE NOT tokens.used
        )
      SQL
    end
  end

  def down; end
end
