class CloseOpenProlongTokenWizards < ActiveRecord::Migration[8.1]
  PROLONGED = 200
  UPDATES_REFUSED = 130

  def up
    safety_assured do
      execute <<~SQL.squish
        UPDATE prolong_token_wizards
        SET status = #{PROLONGED}, updated_at = NOW()
        WHERE status IS NULL OR status NOT IN (#{UPDATES_REFUSED}, #{PROLONGED})
      SQL
    end
  end

  def down; end
end
