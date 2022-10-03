class SIADE::V2::Responses::AbstractDGFIPResponse < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'DGFIP - Adélie'
  end

  def set_error_message_for_potential_not_found_error
    (@errors ||= []) << DGFIPPotentialNotFoundError.new

    @http_code = 502
  end
end
