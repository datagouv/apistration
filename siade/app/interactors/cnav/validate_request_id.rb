class CNAV::ValidateRequestId < ValidateUuid
  def attribute
    :request_id
  end
end
