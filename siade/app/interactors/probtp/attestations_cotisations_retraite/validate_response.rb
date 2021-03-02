class PROBTP::AttestationsCotisationsRetraite::ValidateResponse < ValidateResponse
  def call
    if server_error?
    elsif attestation_not_found?
    else
      return
    end
  end

  private

  def server_error?
    #FIXME
    false
  end

  def attestation_not_found?
    #FIXME
    false
  end
end
