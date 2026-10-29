module ProviderPingsHelper
  BADGE_COLORS = {
    pending: 'info',
    ok: 'success',
    maintenance: 'warning',
    unknown: nil,
    ko: 'error'
  }.freeze

  STATUS_ORDER = %i[ko maintenance unknown ok pending].freeze

  def provider_pings_failing_first(pings, checks)
    pings.each_with_index.sort_by { |ping, index|
      [STATUS_ORDER.index(provider_ping_status(checks[ping.url])), index]
    }.map(&:first)
  end

  def provider_ping_badge(check)
    status = provider_ping_status(check)

    content_tag(:p, t("shared.provider_pings.statuses.#{status}"), class: ['fr-badge', 'fr-badge--sm', ("fr-badge--#{BADGE_COLORS.fetch(status)}" if BADGE_COLORS.fetch(status))])
  end

  def provider_ping_status_page_url
    "https://status.#{namespace.delete_prefix('api_')}.api.gouv.fr"
  end

  private

  def provider_ping_status(check)
    check&.status || :pending
  end
end
