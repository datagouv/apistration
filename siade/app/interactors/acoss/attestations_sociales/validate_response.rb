class ACOSS::AttestationsSociales::ValidateResponse < URSSAF::AttestationsSociales::ValidateResponse::RawBody
  def handle_errors
    if cannot_deliver_document?
      fail_with_error!(ACOSSError.new(:cannot_deliver_document))
    else
      super
    end
  end

  def json_body_has_errors?
    json_errors.any?
  end
end
