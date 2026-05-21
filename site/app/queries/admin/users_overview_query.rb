class Admin::UsersOverviewQuery
  def initialize(filter)
    @filter = filter
  end

  # card 329
  def total_users
    User.count
  end

  # card 330
  def total_habilitations
    AuthorizationRequest.count
  end

  # card 331
  def total_tokens
    Token.count
  end

  # card 612
  def habilitations_with_successful_call
    AuthorizationRequest
      .joins(:tokens)
      .joins("INNER JOIN access_logs ON access_logs.token_id = tokens.id AND access_logs.status = '200'")
      .where(access_logs: { timestamp: filter.date_from.beginning_of_day.. })
      .distinct
      .count
  end

  private

  attr_reader :filter
end
