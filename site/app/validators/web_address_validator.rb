class WebAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    uri = URI.parse(value)
    record.errors.add(attribute, :invalid) unless %w[http https].include?(uri.scheme) && uri.host.present?
  rescue URI::InvalidURIError
    record.errors.add(attribute, :invalid)
  end
end
