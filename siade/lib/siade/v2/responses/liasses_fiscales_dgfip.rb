class SIADE::V2::Responses::LiassesFiscalesDGFIP < SIADE::V2::Responses::AbstractDGFIPResponse
  def provider_name
    'DGFIP'
  end

  protected

  def adapt_raw_response_code
    if @raw_response.code.to_i != 200
      set_error_message_for_potential_not_found_error
    else
      200
    end
  end
end
