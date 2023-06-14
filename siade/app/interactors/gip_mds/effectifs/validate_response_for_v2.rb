class GIPMDS::Effectifs::ValidateResponseForV2 < GIPMDS::Effectifs::ValidateResponse
  def call
    super
    resource_not_found! unless regime_general_effectifs_present?
  end

  private

  def regime_general_effectifs_present?
    json_body.find do |effectifs|
      effectifs['source'] == 'RG' &&
        effectifs['effectifs'] != 'NC'
    end
  end
end
