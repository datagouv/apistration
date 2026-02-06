class IpWhitelist
  def self.allowed?(allowed_ips, request_ip)
    return true if allowed_ips.blank?

    request_ip_addr = IPAddr.new(request_ip)
    allowed_ips.any? do |ip_or_cidr|
      IPAddr.new(ip_or_cidr).include?(request_ip_addr)
    rescue IPAddr::InvalidAddressError
      false
    end
  rescue IPAddr::InvalidAddressError
    false
  end
end
