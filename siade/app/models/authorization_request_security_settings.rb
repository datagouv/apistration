class AuthorizationRequestSecuritySettings < ApplicationRecord
  belongs_to :authorization_request

  def ip_allowed?(request_ip)
    IpWhitelist.allowed?(allowed_ips, request_ip)
  end
end
