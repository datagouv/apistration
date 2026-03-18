# frozen_string_literal: true

class SIADE::V2::Responses::DnsResolutionError < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= ::DnsResolutionError.new(provider_name)
  end

  def http_code
    502
  end
end
