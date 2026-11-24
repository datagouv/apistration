class DirectPodRequestConstraint
  FORWARDED_HEADERS = %w[HTTP_X_FORWARDED_HOST HTTP_X_FORWARDED_FOR HTTP_X_FORWARDED_PROTO HTTP_FORWARDED].freeze

  def matches?(request)
    return false if FORWARDED_HEADERS.any? { |header| request.has_header?(header) }

    IPAddr.new(request.get_header('HTTP_HOST').to_s.sub(/:\d+\z/, ''))
    true
  rescue IPAddr::InvalidAddressError
    false
  end
end
