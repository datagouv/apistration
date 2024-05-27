class RetrieverPayloadPingDriver < RetrieverPingDriver
  attr_reader :key_to_dig, :method_to_test_on_payload

  def perform
    if success? && payload_passes_test?
      :ok
    else
      :bad_gateway
    end
  end

  private

  def payload_passes_test?
    resource_hash.dig(*key_to_dig.split('.')).public_send(method_to_test_on_payload)
  rescue NoMethodError, TypeError
    false
  end

  def resource_hash
    resource_data.to_h.deep_stringify_keys
  end

  def resource_data
    retriever_call.bundled_data.data
  end

  def build_context(driver_params)
    super
    @key_to_dig = driver_params.fetch(:key_to_dig)
    @method_to_test_on_payload = driver_params.fetch(:method_to_test_on_payload)
  end
end
