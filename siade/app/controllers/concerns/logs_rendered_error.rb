module LogsRenderedError
  extend ActiveSupport::Concern

  def append_info_to_payload(payload)
    super

    fields = RenderedError.log_fields

    return if fields.blank?

    payload[:parameters] ||= {}
    payload[:parameters].merge!(fields)

    LogStasher::CustomFields.add(:parameters)
  end
end
