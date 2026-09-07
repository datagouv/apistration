class CNAV::ValidateRequestId < ValidateUuid
  raises UnprocessableEntityError, field: :request_id

  def attribute
    :request_id
  end
end
