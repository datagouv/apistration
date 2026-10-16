class TokenStatsFacade
  PERIODS = {
    last_10_minutes: 10.minutes,
    last_30_hours: 30.hours,
    last_8_days: 8.days
  }.freeze

  STATUS_CATEGORIES = {
    success: %w[200 206],
    not_found: %w[404 451],
    invalid_request: %w[422 400],
    unauthorized: %w[401 403],
    internal_error: %w[500],
    provider_error: %w[502 503 504]
  }.freeze

  CATEGORIES = [*STATUS_CATEGORIES.keys, :other].freeze

  LAST_REQUESTS_LIMIT = 10

  def initialize(token)
    @token = token
  end

  def status_breakdown(period)
    @token.access_logs
      .since(PERIODS.fetch(period).ago)
      .group(:status)
      .count
      .each_with_object(Hash.new(0)) { |(status, count), breakdown| breakdown[status_category(status)] += count }
      .sort_by { |category, _| CATEGORIES.index(category) }
      .to_h
  end

  def last_requests
    @token.access_logs.order(timestamp: :desc).limit(LAST_REQUESTS_LIMIT)
  end

  private

  def status_category(status)
    STATUS_CATEGORIES.find { |_, statuses| statuses.include?(status) }&.first || :other
  end
end
