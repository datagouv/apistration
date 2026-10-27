class EditorToken::UpdateAllowedIps < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.ip_allowlist.changed',
    target: :editor_token,
    computed_details: ->(context) { allowlist_change(context) },
    only_if: ->(context) { context.previous_allowed_ips.sort != context.editor_token.allowed_ips_as_strings.sort }

  organize EditorToken::UpdateAllowedIpsModel,
    SecurityEvent::Track

  def self.allowlist_change(context)
    allowed_ips = context.editor_token.allowed_ips_as_strings

    {
      editor_id: context.editor_token.editor_id,
      previous_allowed_ips: context.previous_allowed_ips,
      allowed_ips:,
      added_allowed_ips: allowed_ips - context.previous_allowed_ips
    }
  end
end
