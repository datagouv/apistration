class RetrieverPingDriver < ApplicationPingDriver
  attr_reader :retriever, :retriever_params, :operation_id

  def perform
    if success?
      :ok
    else
      :bad_gateway
    end
  end

  private

  def success?
    @success ||= retriever_call.success?
  end

  def retriever_call
    @retriever_call ||= retriever.call(params: retriever_params, operation_id:, recipient: JwtTokenService::DINUM_SIRET)
  end

  def build_context(driver_params)
    @retriever_params = driver_params.fetch(:params)
    @retriever = Kernel.const_get(driver_params.fetch(:retriever))
    @operation_id = "ping_#{driver_params.fetch(:retriever).underscore.gsub('/', '_')}"
  end
end
