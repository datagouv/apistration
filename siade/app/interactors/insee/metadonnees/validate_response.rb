class INSEE::Metadonnees::ValidateResponse < INSEE::ValidateResponse
  private

  def valid_json?
    json_body.any? &&
      json_body[0]['code'].present?
  end
end
