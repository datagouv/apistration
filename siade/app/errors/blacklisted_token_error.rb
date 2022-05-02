# frozen_string_literal: true

class BlacklistedTokenError < UnauthorizedError
  def code
    '00105'
  end
end
