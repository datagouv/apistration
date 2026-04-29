module OrganizersMethodsHelpers
  def extract_http_code(retriever)
    return retriever.mocked_data[:status] if retriever.mocked_data
    return :ok if retriever.errors.blank?

    Errors::HTTPStatusForKind::KIND_TO_STATUS.each do |kind, status|
      return status if at_least_one_error_kind_of?(kind, retriever)
    end

    raise 'No valid HTTP status'
  end
end
