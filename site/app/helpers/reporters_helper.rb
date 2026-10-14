module ReportersHelper
  REPORTER_STATUS_BADGE_VARIANTS = {
    'submitted' => 'new',
    'changes_requested' => 'warning',
    'validated' => 'success',
    'refused' => 'error',
    'revoked' => 'error'
  }.freeze

  def reporter_authorization_request_status_badge(authorization_request)
    variant = REPORTER_STATUS_BADGE_VARIANTS[authorization_request.status]

    tag.p(
      t("api_particulier.reporters.index.status.#{authorization_request.status}", default: authorization_request.status),
      class: ['fr-badge', 'fr-badge--sm', ("fr-badge--#{variant}" if variant)]
    )
  end
end
