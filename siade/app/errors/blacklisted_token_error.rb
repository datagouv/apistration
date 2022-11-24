# frozen_string_literal: true

class BlacklistedTokenError < UnauthorizedError
  attr_reader :api

  def initialize(api)
    @api = api
  end

  def code
    '00105'
  end

  def detail
    format(super, dashboard_url:)
  end

  private

  def dashboard_url
    "https://#{api}.api.gouv.fr/compte"
  end
end
