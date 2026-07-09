class AllowedIpsValidator < ActiveModel::EachValidator
  MAX_ENTRIES = 10
  MIN_IPV4_PREFIX = 24

  def validate_each(record, attribute, value)
    return if value.blank?

    record.errors.add(attribute, :too_many_ips, count: MAX_ENTRIES) if value.size > MAX_ENTRIES

    entries(record, attribute, value).each { |entry| validate_entry(record, attribute, entry) }
  end

  private

  def entries(record, attribute, value)
    return value unless record.respond_to?(:read_attribute_before_type_cast)

    raw = record.read_attribute_before_type_cast(attribute)
    raw.is_a?(Array) ? raw : value
  end

  def validate_entry(record, attribute, entry)
    ip = parse(entry)

    return record.errors.add(attribute, :invalid_ip, entry:) if ip.nil?
    return record.errors.add(attribute, :ip_range_too_wide, entry:) if too_wide?(ip)

    record.errors.add(attribute, :reserved_ip, entry:) if reserved?(ip)
  end

  def parse(entry)
    entry.is_a?(IPAddr) ? entry : IPAddr.new(entry.to_s)
  rescue IPAddr::Error
    nil
  end

  def too_wide?(addr)
    addr.prefix.zero? || (addr.ipv4? && addr.prefix < MIN_IPV4_PREFIX)
  end

  def reserved?(addr)
    addr.private? || addr.loopback? || addr.link_local?
  end
end
