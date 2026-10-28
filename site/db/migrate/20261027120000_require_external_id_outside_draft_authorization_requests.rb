class RequireExternalIdOutsideDraftAuthorizationRequests < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  RULE = "status IS NOT DISTINCT FROM 'draft' OR COALESCE(btrim(external_id), '') <> ''".freeze
  ORPHANS = "SELECT id FROM authorization_requests WHERE NOT (#{RULE})".freeze
  ORPHAN_TOKENS = "SELECT id FROM tokens WHERE authorization_request_model_id IN (#{ORPHANS})".freeze

  def up
    safety_assured do
      transaction { delete_orphans }
    end

    add_check_constraint :authorization_requests, RULE, name: 'external_id_required_outside_draft', validate: false
    validate_check_constraint :authorization_requests, name: 'external_id_required_outside_draft'
  end

  def down
    remove_check_constraint :authorization_requests, name: 'external_id_required_outside_draft'
  end

  private

  def delete_orphans
    execute "DELETE FROM magic_links WHERE token_id IN (#{ORPHAN_TOKENS})"
    execute "DELETE FROM prolong_token_wizards WHERE token_id IN (#{ORPHAN_TOKENS})"
    execute "DELETE FROM tokens WHERE id IN (#{ORPHAN_TOKENS})"
    execute "DELETE FROM user_authorization_request_roles WHERE authorization_request_id IN (#{ORPHANS})"
    execute "DELETE FROM authorization_request_security_settings WHERE authorization_request_id IN (#{ORPHANS})"
    execute "DELETE FROM editor_delegations WHERE authorization_request_id IN (#{ORPHANS})"
    execute "DELETE FROM authorization_requests WHERE id IN (#{ORPHANS})"
  end
end
